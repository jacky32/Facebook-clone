class ChangeDefaultCommunityOnPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :community_id, true
    change_column_default :posts, :community_id, :null
  end
end
