class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.integer :admin_id, null: false, foreign_key: true
      t.text :info

      t.timestamps
    end
  end
end
