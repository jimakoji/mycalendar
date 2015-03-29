class AddUserIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :user_id, :integer
    add_column :events, :public, :boolean, :default => false

    add_index :events, [:user_id, :end_time]
  end
end
