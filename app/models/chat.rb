class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  has_many :messages

  validates_presence_of :sender, :receiver

  def self.exists?(sender, receiver)
    option1 = !Chat.where(sender_id: sender.id, receiver_id: receiver.id).empty?
    option2 = !Chat.where(sender_id: receiver.id, receiver_id: sender.id).empty?
    option1 || option2
  end

  def self.retrieve(sender, receiver)
    if Chat.where(sender_id: sender.id, receiver_id: receiver.id).empty?
      Chat.where(sender_id: receiver.id, receiver_id: sender.id).first
    else
      Chat.where(sender_id: sender.id, receiver_id: receiver.id).first
    end
  end

  def other_user(user)
    if user == sender
      receiver
    else
      sender
    end
  end
end
