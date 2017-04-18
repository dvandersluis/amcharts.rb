require 'mechanize'
require 'zip'

class Amcharts < Thor
  include Thor::Actions

  desc :update, "Update AmCharts to the latest version"
  method_option :ask, type: :boolean, default: false, aliases: '--no-force'
  def update
    thor 'amcharts:update:charts', ask: options[:ask]
    thor 'amcharts:update:stocks'
    thor 'amcharts:update:version'
  end
end

class Amcharts::Update < Thor
  include Thor::Actions

  desc :charts, "Update AmCharts Charts package"
  method_option :ask, type: :boolean, default: false, aliases: '--no-force'
  def charts
    path = download_zip('http://www.amcharts.com/dl/javascript-charts/')

    say_status :updating, "Charts package to version #{get_version}.", :green

    Zip::File.open(path) do |zipfile|
      load_files(zipfile, %w(changeLog.txt licence.txt thirdPartySoftwareList.txt))

      # Images and Patterns go into the images asset dir
      images = load_files(zipfile, 'amcharts/images/**/*', :images) { |f| File.basename(f) }
      patterns = load_files(zipfile, 'amcharts/patterns/**/*', :images) { |f| Pathname.new('patterns').join(f.gsub(%r{\Aamcharts/patterns/}, '')) }

      # All other files go into the javascripts asset dir
      scripts = zipfile.glob('amcharts/**/*') - images - patterns
      load_files(zipfile, scripts) { |f| f.gsub(%r{\Aamcharts/}, '') }
    end
  end

  desc :stocks, "Update AmCharts Stocks package"
  def stocks
    path = download_zip('http://www.amcharts.com/dl/stock-chart/')

    say_status :updating, "Stock package to version #{get_version}.", :green

    Zip::File.open(path) do |zipfile|
      load_files(zipfile, 'amcharts/*.css', :stylesheets) { |f| File.basename(f) }
      load_files(zipfile, 'amcharts/amstock.js') { 'amstock.js' }
    end
  end

  desc :version, "Update amcharts.rb version to match amcharts javascript files"
  def version
    in_root do
      path = Pathname.new(Dir.getwd).join("lib/amcharts/version.rb")
      run %|sed -i '' -E 's/VERSION = "[^"]+"/VERSION = "#{get_version}.0"/' #{path}|
    end
  end

private

  def load_files(zipfile, files, type = :javascripts)
    files = zipfile.glob(files) unless files.is_a?(Array)

    files.each do |file|
      entry = zipfile.find_entry(file)
      name = block_given? ? yield(entry.name) : entry.name

      if entry.directory?
        empty_directory assets_path(type).join(name)
      elsif entry.file?
        create_file assets_path(type).join(name), entry.get_input_stream.read, force: !options[:ask]
      end
    end
  end

  def download_zip(link)
    t = Tempfile.new('amcharts')
    mechanize_agent.get(link).save!(t.path)
    t
  end

  def get_version
    @version ||= begin
      page = mechanize_agent.get('http://www.amcharts.com/javascript-charts/changelog/')
      page.search('.entry-content h2').first.text
    end
  end

  def mechanize_agent
    @agent ||= Mechanize.new.tap do |agent|
      agent.pluggable_parser['application/zip'] = Mechanize::Download
    end
  end

  def assets_path(type = :javascripts)
    @assets_path ||= {}
    @assets_path[type] ||= begin
      path = nil
      in_root { path = Pathname.new(Dir.getwd).join("vendor/assets/#{type}/amcharts") }
      path
    end
  end
end
