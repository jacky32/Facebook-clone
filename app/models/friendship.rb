class Friendship < ApplicationRecord
  belongs_to :user

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
    option1 = Friendship.where(user_id: id1, friend_id: id2)[0]
    option2 = Friendship.where(user_id: id2, friend_id: id1)[0]
    return option2 if option1.nil?
    return option1 if option2.nil?
  end
end
