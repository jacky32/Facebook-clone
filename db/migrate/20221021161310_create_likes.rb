class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :likeable_id
      t.string :likeable_type

      t.timestamps
    end
    add_index :likes, %i[user_id likeable_id likeable_type], unique: true
  end
end
