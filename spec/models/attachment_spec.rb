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

require 'spec_helper'

describe Attachment do
  pending "add some examples to (or delete) #{__FILE__}"
end
