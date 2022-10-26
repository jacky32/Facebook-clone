class Friendship < ApplicationRecord
  belongs_to :user

  def self.accepted?(id1, id2)
    option1 = !Friendship.where(user_id: id1, friend_id: id2, accepted: true).empty?
    option2 = !Friendship.where(user_id: id2, friend_id: id1, accepted: true).empty?
    option1 || option2
  end
end
