# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  start_time  :datetime
#  end_time    :datetime
#  allday      :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  editable    :boolean          default(TRUE)
#  classname   :string(255)
#  user_id     :integer
#  public      :boolean          default(FALSE)
#

require 'spec_helper'

describe Event do

  let(:user) { FactoryGirl.create(:user) }
  before { @event = user.events.build(title: "test",
                                      description: "Lorem ipsum",
                                      start_time: DateTime.new(2014, 1, 24, 00, 00, 00),
                                      end_time:   DateTime.new(2014, 1, 24, 01, 00, 00),
                                      allday: false,
                                      editable: true,
                                      public: false,
                                      classname: "classname_red"
                                      )
         }

  subject { @event }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:allday) }
  it { should respond_to(:editable) }
  it { should respond_to(:public) }
  it { should respond_to(:classname) }

  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Event.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @event.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank description" do
    before { @event.description = " " }
    it { should be_valid }
  end

  describe "with content that is too long" do
    before { @event.description = "a" * 141 }
    it { should_not be_valid }
  end

end
