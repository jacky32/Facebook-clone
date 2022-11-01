class AddLastOpenedChatToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_chat_id_opened, :integer, default: :null
  end
end
