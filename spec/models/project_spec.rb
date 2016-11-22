require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) do
    @project = FactoryGirl.build(:project)
  end

  it 'should have a valid factory' do
    expect(@project).to be_valid
  end

  describe 'title' do
    it 'should not be nil' do
      @project.title = nil
      expect(@project).to be_invalid
    end

    it 'should not be empty string' do
      @project.title = ''
      expect(@project).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @project.title = '  '
      expect(@project).to be_invalid
    end

    it 'should be valid' do
      @project.title = 'A valid title'
      expect(@project).to be_valid
    end
  end

  describe 'description' do
    it 'can be nil' do
      @project.description = nil
      expect(@project).to be_valid
    end

    it 'can be empty string' do
      @project.description = ''
      expect(@project).to be_valid
    end

    it 'can consist only of whitespace' do
      @project.description = '  '
      expect(@project).to be_valid
    end

    it 'should be valid' do
      @project.description = 'A valid description'
      expect(@project).to be_valid
    end
  end

  describe 'iterate_service' do
    it 'can be nil' do
      @project.iterate_service = nil
      expect(@project).to be_valid
    end

    it 'can be a valid iterate service' do
      service = FactoryGirl.create(:iterate_service)
      @project.iterate_service = service
      expect(@project).to be_valid
    end

    it 'cannot be an invalid iterate service' do
      service = FactoryGirl.create(:machine_learning_service)
      @project.iterate_service = service
      expect(@project).to be_invalid
    end
  end

  describe 'machine_learning_service' do
    it 'can be nil' do
      @project.machine_learning_service = nil
      expect(@project).to be_valid
    end

    it 'can be a valid machine learning service' do
      service = FactoryGirl.create(:machine_learning_service)
      @project.machine_learning_service = service
      expect(@project).to be_valid
    end

    it 'cannot be an invalid machine learning service' do
      service = FactoryGirl.create(:merge_service)
      @project.machine_learning_service = service
      expect(@project).to be_invalid
    end
  end

  describe 'merge_service' do
    it 'can be nil' do
      @project.merge_service = nil
      expect(@project).to be_valid
    end

    it 'can be a valid merge service' do
      service = FactoryGirl.create(:merge_service)
      @project.merge_service = service
      expect(@project).to be_valid
    end

    it 'cannot be an invalid merge service' do
      service = FactoryGirl.create(:iterate_service)
      @project.merge_service = service
      expect(@project).to be_invalid
    end
  end

  describe 'associated_problem_identifiers' do
    it 'should return an empty list if no service is associated' do
      @project.iterate_service = nil
      @project.machine_learning_service = nil
      @project.merge_service = nil

      expect(@project.associated_problem_identifiers).to eq([])
    end

    it 'should return a singleton if all associated services handle the same problem identifier' do
      @project.iterate_service = FactoryGirl.create(:iterate_service, problem_id: 'NER')
      @project.machine_learning_service = FactoryGirl.create(:machine_learning_service, problem_id: 'NER')
      @project.merge_service = FactoryGirl.create(:merge_service, problem_id: 'NER')

      expect(@project.associated_problem_identifiers).to eq(['NER'])
    end

    it 'should return a set of different problem identifiers if associated services handle them' do
      @project.iterate_service = FactoryGirl.create(:iterate_service, problem_id: 'HyperNER')
      @project.machine_learning_service = FactoryGirl.create(:machine_learning_service, problem_id: 'MegaNER')
      @project.merge_service = FactoryGirl.create(:merge_service, problem_id: 'NER')

      expect(@project.associated_problem_identifiers.sort).to eq(['HyperNER', 'MegaNER', 'NER'].sort)
    end
  end

  describe 'connect_services' do
    it 'should not connect services if no service available' do
      Service.destroy_all
      @project.connect_services
      expect(@project.iterate_service).to eq(nil)
      expect(@project.machine_learning_service).to eq(nil)
      expect(@project.merge_service).to eq(nil)
    end

    it 'should connect services from different types if exactly one service per type exists' do
      Service.destroy_all
      iterate_service = FactoryGirl.create(:iterate_service)
      merge_service = FactoryGirl.create(:merge_service)
      @project.connect_services
      expect(@project.iterate_service).to eq(iterate_service)
      expect(@project.machine_learning_service).to eq(nil)
      expect(@project.merge_service).to eq(merge_service)
    end

    it 'should only connect thoses services where exactly one service per type exists' do
      Service.destroy_all
      FactoryGirl.create(:merge_service)
      FactoryGirl.create(:merge_service, url: 'http://yet-another-dalphi-service.com')
      iterate_service = FactoryGirl.create(:iterate_service)
      @project.connect_services
      expect(@project.iterate_service).to eq(iterate_service)
      expect(@project.machine_learning_service).to eq(nil)
      expect(@project.merge_service).to eq(nil)
    end
  end

  describe 'interfaces' do
    it { should have_and_belong_to_many(:interfaces) }

    it 'can be empty' do
      @project.interfaces = []
      expect(@project).to be_valid
    end

    it 'can contain one' do
      @project.interfaces = [FactoryGirl.build(:interface)]
      expect(@project).to be_valid
    end

    it 'can contain two of different interface types' do
      @project.interfaces = [
        FactoryGirl.build(:interface_text_nominal),
        FactoryGirl.build(:interface_other,
                          template: File.new("#{Rails.root}/spec/fixtures/interfaces/ner_complete.html"))
      ]
      expect(@project).to be_valid
    end

    it 'cannot contain two of same interface type' do
      interface = FactoryGirl.build :interface_text_nominal
      other_interface = FactoryGirl.build :interface_text_nominal,
                                          interface_type: interface.interface_type,
                                          template: File.new("#{Rails.root}/spec/fixtures/interfaces/ner_complete.html")
      @project.interfaces = [
        interface,
        other_interface
      ]
      expect(@project).to be_invalid
    end
  end

  describe 'annotators' do
    it 'should have and belong to many' do
      should have_and_belong_to_many(:annotators)
    end

    it 'can be assigned' do
      @project.save!
      @annotator = FactoryGirl.create :annotator
      expect(@project.annotators.count).to eq(0)

      @project.annotators << @annotator
      @project.save!
      @annotator.reload

      expect(@project.annotators.count).to eq(1)
      expect(@annotator.projects).to include(@project)
    end

    it 'can be unassigned' do
      @project.save!
      @annotator = FactoryGirl.create :annotator
      @project.annotators << @annotator
      @project.save!
      expect(@project.annotators.count).to eq(1)

      @project.annotators.delete(@annotator)
      @project.save!
      @annotator.reload

      expect(@project.annotators.count).to eq(0)
      expect(@annotator.projects).not_to include(@project)
    end
  end

  it { should have_many(:raw_data).dependent(:destroy) }

  it { should have_many(:statistics).dependent(:destroy) }

  it { should belong_to(:admin) }

  describe 'selected_interfaces' do
    it 'should return an empty hash for no necessary interface types' do
      @project.iterate_service = nil
      @project.interfaces = []
      @project.save!
      expect(@project.selected_interfaces).to eq({})
    end

    it 'should return a hash with empty keys for no selected interface types' do
      interface_type = FactoryGirl.create(:interface_type_text_nominal)
      @project.iterate_service = FactoryGirl.create(:iterate_service,
                                                    interface_types: [interface_type])
      @project.interfaces = []
      @project.save!

      expect(@project.selected_interfaces).to eq(
        {
          'text_nominal' => nil
        }
      )
    end

    it "should return selected interfaces' titles grouped by type" do
      interface_type = FactoryGirl.create(:interface_type_text_nominal)
      @project.iterate_service = FactoryGirl.create(:iterate_service,
                                                    interface_types: [interface_type])
      text_nominal_interface = FactoryGirl.create(:interface,
                                                  title: 'interface 1',
                                                  interface_type: interface_type)

      @project.interfaces = [text_nominal_interface]
      @project.save!

      expect(@project.selected_interfaces).to eq(
        {
          'text_nominal' => text_nominal_interface.title
        }
      )
    end

    it "should return selected interfaces' titles grouped by type" do
      text_nominal_interface = FactoryGirl.create(:interface_text_nominal,
                                                  title: 'interface 1')
      other_interface = FactoryGirl.create(:interface_other,
                                           title: 'interface 2')
      @project.iterate_service = FactoryGirl.create(:iterate_service,
                                                    interface_types: [
                                                      text_nominal_interface.interface_type,
                                                      other_interface.interface_type
                                                    ])

      @project.interfaces = [
        text_nominal_interface,
        other_interface
      ]
      @project.save!

      expect(@project.selected_interfaces).to eq(
        {
          'text_nominal' => text_nominal_interface.title,
          'other_interface_type' => other_interface.title
        }
      )
    end
  end

  describe 'necessary_interface_types' do
    it 'should be an empty array for a project with no associated services' do
      @project.iterate_service = nil

      expect(@project.necessary_interface_types).to eq([])
    end

    it 'should be the interface types of associated services' do
      interface_type_1 = FactoryGirl.create(:interface_type)
      iterate_service = FactoryGirl.create(:iterate_service,
                                           interface_types: [interface_type_1])
      @project.iterate_service = iterate_service

      expect(@project.necessary_interface_types).to eq([
        interface_type_1
      ])
    end

    it 'should be the union of interface types of associated services' do
      interface_type_1 = FactoryGirl.create(:interface_type)
      interface_type_2 = FactoryGirl.create(:interface_type_text_nominal)

      iterate_service = FactoryGirl.create(:iterate_service,
                                           interface_types: [interface_type_1, interface_type_2])
      @project.iterate_service = iterate_service

      expect(@project.necessary_interface_types).to eq([
        interface_type_1,
        interface_type_2
      ])
    end

    it 'should not contain interface types of non associated services' do
      interface_type_1 = FactoryGirl.create(:interface_type)
      interface_type_2 = FactoryGirl.create(:interface_type_text_nominal)
      interface_type_3 = FactoryGirl.create(:interface_type_other)

      iterate_service = FactoryGirl.create(:iterate_service,
                                           interface_types: [interface_type_1, interface_type_2])
      not_associated_service = FactoryGirl.create(:iterate_service,
                                                  url: 'http://www.3antworten.de',
                                                  interface_types: [
                                                    interface_type_1,
                                                    interface_type_2,
                                                    interface_type_3
                                                  ])
      @project.iterate_service = iterate_service

      expect(@project.necessary_interface_types).to eq([
        interface_type_1,
        interface_type_2
      ])
    end
  end

  describe 'iterate_data' do
    it 'should be an empty list for no present raw data' do
      @project.raw_data = []
      expect(@project.iterate_data).to eq([])
    end

    it 'should contain raw_datum_id and base64 encoded content for one present raw datum' do
      raw_datum = FactoryGirl.create :raw_datum,
                                     project: @project

      @project.raw_data = [raw_datum]
      expect(@project.iterate_data.size).to eq(1)

      iterate_data = @project.iterate_data.first
      expect(iterate_data[:raw_datum_id]).to eq(raw_datum.id)
      expect(iterate_data[:content]).to eq(
        Base64.encode64(
          File.new(raw_datum.data.path).read
        )
      )
    end

    it 'should contain multiple items for multiple associated raw data' do
      raw_data = [
        FactoryGirl.create(:raw_datum,
                           filename: 'valid1.md',
                           data: File.new("#{Rails.root}/spec/fixtures/text/valid1.md"),
                           project: @project),
        FactoryGirl.create(:raw_datum,
                           filename: 'valid2.md',
                           data: File.new("#{Rails.root}/spec/fixtures/text/valid2.md"),
                           project: @project)
      ]

      @project.raw_data = raw_data

      expect(@project.iterate_data.size).to eq(2)

      @project.iterate_data.each_with_index do |iterate_data, i|
        expect(iterate_data[:raw_datum_id]).to eq(raw_data[i].id)
        expect(iterate_data[:content]).to eq(
          Base64.encode64(
            File.new(raw_data[i].data.path).read
          )
        )
      end
    end
  end

  describe 'merge_data' do
    it 'should be an empty list for no present raw data' do
      @project.raw_data = []
      expect(@project.merge_data).to eq([])
    end

    it 'should be an empty list for no present annotation documents' do
      @project.annotation_documents = []
      expect(@project.merge_data).to eq([])
    end

    it 'should contain corpus_document, content, raw_datum_id and annotation_documents' do
      raw_datum = FactoryGirl.create :raw_datum,
                                     project: @project
      annotation_document = FactoryGirl.create :annotation_document,
                                               raw_datum: raw_datum

      @project.raw_data = [raw_datum]
      expect(@project.merge_data.size).to eq(1)

      merge_data = @project.merge_data.first
      expect(merge_data[:corpus_document][:raw_datum_id]).to eq(raw_datum.id)
      expect(merge_data[:corpus_document][:content]).to eq(
        Base64.encode64(
          File.new(raw_datum.data.path).read
        )
      )
      expect(merge_data[:annotation_documents].size).to eq(1)
      expect(merge_data[:annotation_documents].first).to eq(annotation_document)
    end
  end

  describe 'update_merged_raw_datum' do
    it 'should do nothing for an unmatched raw_datum' do
      raw_datum = FactoryGirl.create :raw_datum,
                                     project: @project
      @project.raw_data = [raw_datum]
      @project.update_merged_raw_datum(
        {
          'raw_datum_id' => (raw_datum.id + 1),
          'content' => Base64.encode64('{"new":"content"}')
        }
      )
      expect(File.new(raw_datum.data.path).read).not_to eq('{"new":"content"}')
    end

    it 'should update the content of a raw_datum' do
      raw_datum = FactoryGirl.create :raw_datum,
                                     project: @project
      @project.raw_data = [raw_datum]
      @project.update_merged_raw_datum(
        {
          'raw_datum_id' => raw_datum.id,
          'content' => Base64.encode64('{"new":"content"}')
        }
      )
      expect(File.new(raw_datum.data.path).read).to eq('{"new":"content"}')
    end
  end

  describe 'zip' do
    it 'should be an empty zip archive for no associated raw data' do
      @project.raw_data = []

      begin
        file1 = Tempfile.new('raw-datum-zip-test1')
        file2 = Tempfile.new('raw-datum-zip-test2')

        Zip::OutputStream.open(file2) { |zos| }
        Zip::File.open(file2.path, Zip::File::CREATE) { |zipfile| }

        expect(@project.zip(file1)).to eq(File.read(file2))
      ensure
        file1.close
        file2.close
        file1.unlink
        file2.unlink
      end
    end

    it 'should be a zip archive containing all raw data' do
      @project.raw_data = [
        FactoryGirl.create(:raw_datum, project: @project),
        FactoryGirl.create(:raw_datum_with_different_data, project: @project)
      ]

      begin
        file = Tempfile.new('raw-datum-zip-test1')

        @project.zip(file)

        Zip::File.open(file) do |zip_file|
          # every zip file exists in raw_data
          zip_file.each do |entry|
            raw_datum = @project.raw_data.find_by(filename: entry.name)
            expect(entry.get_input_stream.read.force_encoding('utf-8')).to eq(File.new(raw_datum.data.path).read)
          end

          # every raw_datum exist in zip files
          @project.raw_data.each do |raw_datum|
            entry = zip_file.glob(raw_datum.filename).first
            expect(entry).not_to eq(nil)
          end
        end
      ensure
        file.close
        file.unlink
      end
    end
  end
end
