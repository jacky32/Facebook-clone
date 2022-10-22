class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :likeable_id
      t.string :likeable_type

      t.timestamps
    end
    add_index :likes, :likeable_id, unique: true
  end
end
