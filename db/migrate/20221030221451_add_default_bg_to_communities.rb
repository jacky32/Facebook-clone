class AddDefaultBgToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :default_background, :text
  end
end
