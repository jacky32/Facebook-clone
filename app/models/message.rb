class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates_presence_of :sender, :receiver, :body

  def self.retrieve(user1, user2)
    sent_messages = user1.sent_messages.where(receiver_id: user2.id)
    received_messages = user1.received_messages.where(sender_id: user2.id)
    messages = sent_messages + received_messages
  end
end
