class Friendship < ApplicationRecord
  belongs_to :user
  after_create :send_friend_request_notification
  before_destroy :delete_friend_request_notification

  def send_friend_request_notification
    new_notification = Notification.create(
      sender_id: user_id,
      receiver_id: friend_id,
      title: "#{User.find(user_id).name} has sent you a friend request!",
      url: "/users/#{user_id}"
    )
    new_notification.save
  end

  def delete_friend_request_notification
    notification = Notification.where(
      sender_id: user_id,
      receiver_id: friend_id,
      title: "#{User.find(user_id).name} has sent you a friend request!",
      url: "/users/#{user_id}"
    ).first
    notification&.destroy
  end

  def self.requested?(id1, id2)
    !Friendship.where(user_id: id1, friend_id: id2, accepted: false).empty?
  end

  def self.accepted?(id1, id2)
    option1 = !Friendship.where(user_id: id1, friend_id: id2, accepted: true).empty?
    option2 = !Friendship.where(user_id: id2, friend_id: id1, accepted: true).empty?
    option1 || option2
  end

  def self.exists?(id1, id2)
    option1 = !Friendship.where(user_id: id1, friend_id: id2).empty?
    option2 = !Friendship.where(user_id: id1, friend_id: id2).empty?
    option1 || option2
  end

  def self.find_by_ids(id1, id2)
    option1 = Friendship.where(user_id: id1, friend_id: id2).first
    option2 = Friendship.where(user_id: id2, friend_id: id1).first
    [option1, option2].each do |opt|
      return opt unless opt.nil?
    end
    false
  end
end
