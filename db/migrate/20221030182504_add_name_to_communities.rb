class AddNameToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :name, :string
  end
end
