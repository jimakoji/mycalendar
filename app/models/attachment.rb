# == Schema Information
#
# Table name: attachments
#
#  id           :integer          not null, primary key
#  file_content :binary(2097152)
#  file_name    :string(255)
#  mime_type    :string(255)
#  file_size    :integer
#  event_id     :integer
#  public       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Attachment < ActiveRecord::Base
  attr_accessible :file_content, :file_name, :mime_type, :file_size, :public

  belongs_to :event

#  validates :event_id, presence: true

#  def self.cleanup
#    Attachment.delete_all(["created_at < ?", 3.months.ago])
#  end

end
