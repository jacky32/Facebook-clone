class Membership < ApplicationRecord
  belongs_to :member, class_name: 'User'
  belongs_to :community, class_name: 'Community'

  def send_invite_notification(sender:, receiver:)
    new_notification = Notification.create(
      sender_id: sender.id,
      receiver_id: receiver.id,
      title: "#{sender.name} has sent you an invite to #{community.name}!",
      url: "/communities/#{community.id}"
    )
    new_notification.save
  end

  def send_join_request_notification(sender:)
    new_notification = Notification.create(
      sender_id: sender.id,
      receiver_id: community.admin.id,
      title: "#{sender.name} has requested to join #{community.name}!",
      url: "/communities/#{community.id}"
    )
    new_notification.save
  end

  def unsend_join_request_notification(sender:)
    notification = Notification.where(
      sender_id: sender.id,
      receiver_id: community.admin.id,
      title: "#{sender.name} has requested to join #{community.name}!",
      url: "/communities/#{community.id}"
    ).first
    notification&.destroy
  end

  def exists?(member_id:, community_id:)
    !Membership.where(member_id:, community_id:).empty?
  end

  # Requested to join
  def self.requested?(member:, community:)
    !Membership.where(member_id: member.id, community_id: community.id, requested: true,
                      confirmed_by_admin: false).empty?
  end

  # Confirmed by admin
  def self.confirmed?(member:, community:)
    !Membership.where(member_id: member.id, community_id: community.id, confirmed_by_admin: true).empty?
  end

  # Invited to community
  def self.invited?(member:, community:)
    !Membership.where(member_id: member.id, community_id: community.id, confirmed_by_admin: false,
                      invited: true).empty?
  end
end
