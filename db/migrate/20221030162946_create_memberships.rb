class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.belongs_to :member
      t.belongs_to :community

      t.timestamps
    end
  end
end
