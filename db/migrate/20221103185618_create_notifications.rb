class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :sender
      t.belongs_to :receiver
      t.text :title
      t.text :url

      t.timestamps
    end
  end
end
