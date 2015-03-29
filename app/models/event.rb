# coding: utf-8
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

class Event < ActiveRecord::Base
  attr_accessible :allday, :description, :end_time, :start_time, :title, :editable, :classname, :public, :file
  belongs_to :user
  has_many   :attachments, dependent: :destroy
  has_many   :files, class_name: "Attachment"
#  accepts_nested_attributes_for :attachments

  validates :title, presence: true
  validates :title, length: {maximum: 50}

  validates :user_id, presence: true

  validates :description, length: {maximum: 140}

#  default_scope order: 'events.start_time ASC'

  validate :start_end_check

  def start_end_check
    errors.add(:end_time, "が開始時間より早くなっているか、同じです。<br/>&emsp;正しい時間を入力してください。") if self.start_time >= self.end_time
  end 


  def self.cleanup
    Event.delete_all(["end_time < ?", 3.months.ago])
  end

end
