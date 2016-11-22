require 'rails_helper'

RSpec.describe InterfaceType, type: :model do
  before(:each) do
    @interface_type = FactoryGirl.build(:interface_type)
  end

  it 'should have a valid factory' do
    expect(@interface_type).to be_valid
  end

  describe 'name' do
    it 'may not be nil' do
      @interface_type.name = nil
      expect(@interface_type).to be_invalid
    end

    it 'may not be empty string' do
      @interface_type.name = ''
      expect(@interface_type).to be_invalid
    end

    it 'can be text_nominal as text string' do
      @interface_type.name = 'ner_complete'
      expect(@interface_type).to be_valid
    end

    it 'can not be another text_nominal' do
      @interface_type.name = 'ner_complete'
      @interface_type.save!

      another_interface_type = FactoryGirl.create(:interface_type_other)
      another_interface_type.name = 'ner_complete'
      expect(another_interface_type).to be_invalid
    end
  end

  describe 'label' do
    it "is the interface's name" do
      @interface_type.name = 'fancy interface'
      expect(@interface_type.label).to eq(@interface_type.name)
    end
  end

  describe 'destroy_abandoned' do
    it 'should destroy abandoned interface types' do
      InterfaceType.destroy_all
      @interface_type = FactoryGirl.create :interface_type,
                                           interfaces: [],
                                           services: [],
                                           annotation_documents: []
      expect(InterfaceType.count).to eq(1)
      InterfaceType.destroy_abandoned
      expect(InterfaceType.count).to eq(0)
    end
  end

  describe 'convert_interface_types' do
    it 'should return [] for nil argument' do
      expect(InterfaceType.convert_interface_types(nil)).to eq([])
    end

    it 'should return [] for empty list argument' do
      expect(InterfaceType.convert_interface_types([])).to eq([])
    end

    it 'should return interface types which are identified by the list of names' do
      InterfaceType.destroy_all
      @first_interface_type = FactoryGirl.create :interface_type,
                                                 name: 'First interface type'
      @second_interface_type = FactoryGirl.create :interface_type,
                                                  name: 'Second interface type'
      expect(
        InterfaceType.convert_interface_types(
          [
            'First interface type',
            'Second interface type'
          ]
        )
      ).to eq(
        [
          @first_interface_type,
          @second_interface_type
        ]
      )
    end
  end

  describe 'test_payload' do
    it 'can be nil' do
      @interface_type.test_payload = nil
      expect(@interface_type).to be_valid
    end

    it 'can be the empty string' do
      @interface_type.test_payload = ''
      expect(@interface_type).to be_valid
    end

    it 'has to be serialized JSON - negative 1' do
      @interface_type.test_payload = 'This is not a JSON string.'
      expect(@interface_type).to be_invalid
    end

    it 'has to be serialized JSON - negative 2' do
      @interface_type.test_payload = '{ This: is not a JSON string. }'
      expect(@interface_type).to be_invalid
    end

    it 'has to be serialized JSON - positive 1' do
      @interface_type.test_payload = '{ "key": "value", "foo": "bar" }'
      expect(@interface_type).to be_valid
    end

    it 'has to be serialized JSON - positive 2' do
      @interface_type.test_payload = '{"options":["Enthält Personennamen","Enthält keine Personennamen"],"content":"Mit dieser Aktienanalyse \"haben wir nichts zu tun\", beteuert [...] mit halbwahren Erfolgsmeldungen hochschummeln.","paragraph_index":10}'
      expect(@interface_type).to be_valid
    end
  end

  it { should have_many(:interfaces) }
  it { should have_and_belong_to_many(:services) }
  it { should have_many(:annotation_documents) }
end
