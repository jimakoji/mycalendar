# encoding: utf-8

require 'spec_helper'

describe "StaticPages" do



  describe "GET /home" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get home_path
      response.status.should be(200)
    end
  end
  #上記まではジェネレーターで自動生成されたもの

  subject { page }

  let(:base_title) { "MyCalendar" }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1', text: 'Welcome to the MyCalendar') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector('title', text: '| Home') }

  end
=begin
  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h2', text: 'Help/使い方の説明') }

  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h2', text: 'About/このサイトについて') }

  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_selector('h2', text: 'Contact/連絡先 E_mail') }

  end
=end
end




