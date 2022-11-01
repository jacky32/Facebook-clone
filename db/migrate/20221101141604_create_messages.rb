class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.belongs_to :sender
      t.belongs_to :receiver
      t.text :body

      t.timestamps
    end
  end
end
