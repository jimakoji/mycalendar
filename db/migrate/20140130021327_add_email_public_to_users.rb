class AddEmailPublicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_public, :boolean, default: false
  end
end
