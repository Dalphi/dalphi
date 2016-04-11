require 'rails_helper'

RSpec.describe "projects/new", :type => :view do
  before(:each) do
    assign(:project, Project.new(
      :title => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input#project_title[name=?]", "project[title]"

      assert_select "textarea#project_description[name=?]", "project[description]"
    end
  end
end
