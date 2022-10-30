class AddCommunityReferenceToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :community, default: :null, foreign_key: true
  end
end
