class ChangeUserLastName < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :last_name, :string, null: true
  end
end
