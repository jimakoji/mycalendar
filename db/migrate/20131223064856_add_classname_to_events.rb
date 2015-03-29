class AddClassnameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :classname, :string
  end
end
