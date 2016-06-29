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

    it 'should not be assigned twice' do
      test_title = 'Super Interface'

      @another_interface = FactoryGirl.build(:interface_2)
      expect(@another_interface).to be_valid

      @another_interface.title = test_title
      @another_interface.template = test_title
      @another_interface.save!

      @interface.title = test_title
      expect(@interface).to be_invalid
    end

    it 'can be different' do
      test_title_1 = 'Wow Interface'
      test_title_2 = 'Incredible Interface'

      @another_interface = FactoryGirl.build(:interface_2)
      expect(@another_interface).to be_valid

      @another_interface.title = test_title_1
      @another_interface.save!

      @interface.title = test_title_2
      expect(@interface).to be_valid
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

    it 'can be text_nominal as integer 0' do
      @interface.interface_type = 0
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
    it 'should not be nil' do
      @interface.template = nil
      expect(@interface).to be_invalid
    end

    it 'should not be empty' do
      @interface.template = ''
      expect(@interface).to be_invalid
      @interface.template = '   '
      expect(@interface).to be_invalid
    end

    describe 'should be unique and' do
      it 'should not be assigned twice' do
        test_template = 'Template with {{values}}'

        @another_interface = FactoryGirl.build(:interface_2)
        expect(@another_interface).to be_valid

        @another_interface.template = test_template
        @another_interface.save!

        @interface.template = test_template
        expect(@interface).to be_invalid
      end

      it 'can be different' do
        test_template_1 = 'Template with {{values}}'
        test_template_2 = 'Template with more {{values}}'

        @another_interface = FactoryGirl.build(:interface_2)
        expect(@another_interface).to be_valid

        @another_interface.template = test_template_1
        @another_interface.save!

        @interface.template = test_template_2
        expect(@interface).to be_valid
      end
    end
  end

  describe 'stylesheet' do
    it 'can be nil' do
      @interface.stylesheet = nil
      expect(@interface).to be_valid
    end

    it 'can be empty' do
      @interface.stylesheet = ''
      expect(@interface).to be_valid
      @interface.stylesheet = '   '
      expect(@interface).to be_valid
    end

    it 'can be a valid stylesheet' do
      @interface.stylesheet = 'p { text-align: center; font-size: 2rem; }'
      expect(@interface).to be_valid
    end

    it 'can be a valid SCSS stylesheet' do
      @interface.stylesheet = '$strong-font-size: 2rem; p { text-align: center; strong { font-size: $strong-font-size; } }'
      expect(@interface).to be_valid
    end

    it 'can not be an invalid stylesheet' do
      @interface.stylesheet = 'p { text-align: very-middel & font-size: large };'
      expect(@interface).to be_invalid
    end
  end

  describe 'java_script' do
    it 'can be nil' do
      @interface.java_script = nil
      expect(@interface).to be_valid
    end

    it 'can be empty' do
      @interface.java_script = ''
      expect(@interface).to be_valid
      @interface.java_script = '   '
      expect(@interface).to be_valid
    end

    it 'can be a valid java script' do
      @interface.java_script = 'alert("wow, such JS");'
      expect(@interface).to be_valid
    end

    it 'can be a valid coffee script' do
      @interface.java_script = '
        test: ->
          alert "much coffee!"

        test()
      '
      expect(@interface).to be_valid
    end

    it 'can not be an invalid java_script' do
      @interface.java_script = 'alert(this is not a JS string!)'
      expect(@interface).to be_invalid
    end
  end

  # describe 'projects' do
  #   it { should have_many(:projects) }
  # end

end
