require 'spec_helper'

describe "information/new" do
  before(:each) do
    assign(:information, stub_model(Information,
      :title => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new information form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => information_index_path, :method => "post" do
      assert_select "input#information_title", :name => "information[title]"
      assert_select "input#information_description", :name => "information[description]"
    end
  end
end
