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

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
