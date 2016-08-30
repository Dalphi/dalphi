require 'rails_helper'

RSpec.describe Interface, type: :model do
  before(:each) do
    @interface = FactoryGirl.build(:interface)
  end

  it 'should have a valid factory' do
    expect(@interface).to be_valid
  end

  describe 'title' do
    it 'should not be nil' do
      @interface.title = nil
      expect(@interface).to be_invalid
    end

    it 'should not be empty string' do
      @interface.title = ''
      expect(@interface).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @interface.title = '  '
      expect(@interface).to be_invalid
    end

    it 'should be valid' do
      @interface.title = 'A valid title'
      expect(@interface).to be_valid
    end

    it 'should not be assigned twice for non disjunct sets of problem identifiers' do
      @interface.title = 'Duplicate title'
      @interface.associated_problem_identifiers = %w(ner superNER)
      @interface.save!

      @another_interface = FactoryGirl.build(:interface,
                                             title: 'Duplicate title',
                                             associated_problem_identifiers: %w(ner ultraNER))
      expect(@another_interface).to be_invalid
    end

    it 'can be assigned twice for disjunct sets of problem identifiers' do
      @interface.title = 'Duplicate title'
      @interface.associated_problem_identifiers = %w(ner superNER)
      @interface.save!

      @another_interface = FactoryGirl.build(:interface,
                                             title: 'Duplicate title',
                                             associated_problem_identifiers: %w(ultraNER hyperNER))
      expect(@another_interface).to be_valid
    end

    it 'can be different for non disjunct sets of problem identifiers' do
      @interface.title = 'Different title'
      @interface.associated_problem_identifiers = %w(ner superNER)
      @interface.save!

      @another_interface = FactoryGirl.build(:interface,
                                             title: 'Even more different title',
                                             associated_problem_identifiers: %w(ner ultraNER))
      expect(@another_interface).to be_valid
    end
  end

  describe 'interface_type' do
    it 'may not be nil' do
      @interface.interface_type = nil
      expect(@interface).to be_invalid
    end

    it 'may not be empty string' do
      @interface.interface_type = ''
      expect(@interface).to be_invalid
    end

    it 'can be text_nominal as text string' do
      @interface.interface_type = 'text_nominal'
      expect(@interface).to be_valid
    end
  end

  describe 'associated_problem_identifiers' do
    it 'is an array' do
      expect(@interface.associated_problem_identifiers.class).to eq(Array)
    end

    it 'may not be nil' do
      @interface.associated_problem_identifiers = nil
      expect(@interface).to be_invalid
    end

    it 'may not be an empty array' do
      @interface.associated_problem_identifiers = []
      expect(@interface).to be_invalid
    end

    it 'can be an array containing a problem id string' do
      @interface.associated_problem_identifiers = ['ner']
      expect(@interface).to be_valid
    end

    it 'can be an array containing multiple problem id strings' do
      @interface.associated_problem_identifiers = ['ner', 'image classification']
      expect(@interface).to be_valid
    end
  end

  describe 'template' do
    it 'can be nil' do
      @interface.template = nil
      expect(@interface).to be_valid
    end

    it 'can be empty' do
      @interface.template = File.new("#{Rails.root}/spec/fixtures/interfaces/empty.html")
      expect(@interface).to be_valid
    end

    it 'can be a valid template' do
      @interface.template = File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.html")
      expect(@interface).to be_valid
    end
  end

  describe 'stylesheet' do
    it 'can be nil' do
      @interface.stylesheet = nil
      expect(@interface).to be_valid
    end

    it 'can be empty' do
      @interface.stylesheet = File.new("#{Rails.root}/spec/fixtures/interfaces/empty.css")
      expect(@interface).to be_valid
    end

    it 'can be a valid stylesheet' do
      @interface.stylesheet = File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.css")
      expect(@interface).to be_valid
    end

    it 'can be a valid SCSS stylesheet' do
      @interface.stylesheet = File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.css")
      expect(@interface).to be_valid
    end

    it 'cannot be an invalid stylesheet' do
      @interface.stylesheet = File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal_invalid.css")
      expect(@interface).to be_invalid
    end
  end

  describe 'compiled_stylesheet' do
    it 'can be nil or empty iff stylesheet is nil' do
      @interface.stylesheet = nil
      @interface.compiled_stylesheet = nil
      expect(@interface).to be_valid

      @interface.stylesheet = File.new("#{Rails.root}/spec/fixtures/interfaces/empty.css")
      @interface.compiled_stylesheet = ''
      expect(@interface).to be_valid
    end

    it 'is the compiled version of the stylesheet' do
      begin
        file = Tempfile.new('stylesheet')
        file.write('$strong-font-size: 2rem; p { text-align: center; strong { font-size: $strong-font-size; } }')
        file.rewind

        @interface.stylesheet = file
        @interface.save
        @interface.reload

        expect(@interface.compiled_stylesheet).to eq(
          <<-CSS.gsub(/^ {12}/, '')
            .annotation-interface p {
              text-align: center; }
              .annotation-interface p strong {
                font-size: 2rem; }
          CSS
        )
      ensure
        file.close
        file.unlink
      end
    end
  end

  describe 'java_script' do
    it 'can be nil' do
      @interface.java_script = nil
      expect(@interface).to be_valid
    end

    it 'can be empty' do
      @interface.java_script = File.new("#{Rails.root}/spec/fixtures/interfaces/empty.js")
      expect(@interface).to be_valid
    end

    it 'can be a valid java script' do
      @interface.java_script = File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.js")
      expect(@interface).to be_valid
    end

    it 'can be a valid coffee script' do
      @interface.java_script = File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.js")
      expect(@interface).to be_valid
    end

    it 'cannot be an invalid coffee script' do
      @interface.java_script = File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal_invalid.js")
      expect(@interface).to be_invalid
    end
  end

  it { should have_and_belong_to_many(:projects) }

  describe 'compiled_java_script' do
    it 'can be nil or empty iff java_script is nil' do
      @interface.java_script = nil
      @interface.compiled_java_script = nil
      expect(@interface).to be_valid

      @interface.java_script = File.new("#{Rails.root}/spec/fixtures/interfaces/empty.js")
      @interface.compiled_java_script = ''
      expect(@interface).to be_valid
    end

    it 'is the compiled version of the java_script' do
      begin
        file = Tempfile.new('java_script')
        file.write(
          <<-COFFEE.gsub(/^ {12}/, '')
            test: ->
              alert "much coffee!"

            test()
          COFFEE
        )
        file.rewind

        @interface.java_script = file
        @interface.save
        @interface.reload

        expect(@interface.compiled_java_script).to eq(
          <<-JS.gsub(/^ {12}/, '')
            (function() {
              ({
                test: function() {
                  return alert(\"much coffee!\");
                }
              });

              test();

            }).call(this);
          JS
        )
      ensure
        file.close
        file.unlink
      end
    end
  end
end
