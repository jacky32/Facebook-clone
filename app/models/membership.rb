class Membership < ApplicationRecord
  belongs_to :member, class_name: 'User'
  belongs_to :community, class_name: 'Community'

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
