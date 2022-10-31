class AddRequestedConfirmedToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :requested, :boolean, default: false
    add_column :memberships, :confirmed_by_admin, :boolean, default: false
    add_column :memberships, :invited, :boolean, default: false
  end
end
