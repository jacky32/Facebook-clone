class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.belongs_to :chat
      t.belongs_to :user
      t.text :body

      t.timestamps
    end
  end
end
