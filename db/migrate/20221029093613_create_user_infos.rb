class CreateUserInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :user_infos do |t|
      t.date :birthday
      t.string :school
      t.string :city
      t.string :workplace
      t.text :details
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
