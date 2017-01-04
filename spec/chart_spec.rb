require 'amcharts/chart'

describe AmCharts::Chart do
  before { described_class.clear_defaults }

  describe '.defaults' do
    it 'should be an empty hash if no defaults are defined' do
      described_class.defaults.should == {}
    end

    it 'should allow defaults to be specified multiple times' do
      described_class.defaults do |c|
        c.foo = :bar
      end

      described_class.defaults do |c|
        c.name = 'test'
      end

      described_class.defaults.should == { foo: :bar, name: 'test' }
    end

    it 'should not bleed between subclasses' do
      subclass1 = Class.new(described_class)
      subclass2 = Class.new(described_class)

      subclass1.defaults do |c|
        c.foo = :bar
      end

      subclass1.defaults.should == { foo: :bar }
      subclass2.defaults.should be_empty
      described_class.defaults.should be_empty
    end

    it 'should inherit from superclasses' do
      subclass = Class.new(described_class)
      
      described_class.defaults do |c|
        c.foo = :bar
      end

      subclass.defaults.should == { foo: :bar }
    end

    context 'when defaults are specified' do
      before do
        described_class.defaults do |c|
          c.foo = :bar
        end
      end

      it 'should add default settings' do
        described_class.defaults.should == { foo: :bar }
      end

      it 'should allow defaults to be overridden' do
        described_class.defaults do |c|
          c.foo = :quux
        end

        described_class.defaults.should == { foo: :quux }
      end
    end
  end

  describe '#dimensions' do
    context 'setting width and height with the same assignment' do
      before { subject.dimensions = '800x600' }

      its(:width) { should == 800 }
      its(:height) { should == 600 }
    end

    context 'not setting width and height' do
      its(:width) { should be_nil }
      its(:height) { should be_nil }
    end
  end

  describe '#new' do
    it 'should add settings from the given block' do
      chart = described_class.new do |c|
        c.foo = :bar
      end

      chart.settings[:foo].should == :bar
    end

    context 'with default settings' do
      before do
        described_class.defaults do |c|
          c.font_family = 'Arial'
        end
      end

      subject { described_class.new }

      it 'should apply the default settings to a new chart' do
        subject.settings[:font_family].should == 'Arial'
      end

      it 'should allow default settings to be overridden' do
        chart = described_class.new do |c|
          c.font_family = 'Wingdings'
        end

        chart.settings[:font_family].should == 'Wingdings'
      end
    end
  end

  describe '#update_settings' do
    subject do
      described_class.new do |c|
        c.foo = :bar
      end
    end

    it 'should add new settings' do
      subject.update_settings { |c| c.baz = :quux }
      subject.settings[:foo].should == :bar
      subject.settings[:baz].should == :quux
    end

    it 'should override existing settings' do
      subject.update_settings { |c| c.foo = :baz }
      subject.settings[:foo].should == :baz
    end

    it 'should return the chart' do
      subject.update_settings{}.should == subject
    end
  end
end
