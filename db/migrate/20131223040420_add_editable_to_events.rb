class AddEditableToEvents < ActiveRecord::Migration
  def change
    add_column :events, :editable, :boolean, default: true
  end
end
