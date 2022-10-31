class AddPrivateToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :is_private, :boolean, default: false
  end
end
