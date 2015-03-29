# == Schema Information
#
# Table name: information
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Information < ActiveRecord::Base
  attr_accessible :description, :title

  validates :title,  presence: true, length: { maximum: 50 }
  validates :description,  presence: true, length: { maximum: 140 }

  default_scope order: 'information.created_at DESC'

end
