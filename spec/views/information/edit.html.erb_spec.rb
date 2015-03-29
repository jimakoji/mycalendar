require 'spec_helper'

describe "information/edit" do
  before(:each) do
    @information = assign(:information, stub_model(Information,
      :title => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit information form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => information_index_path(@information), :method => "post" do
      assert_select "input#information_title", :name => "information[title]"
      assert_select "input#information_description", :name => "information[description]"
    end
  end
end
