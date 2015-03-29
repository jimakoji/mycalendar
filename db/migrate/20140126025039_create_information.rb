class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
