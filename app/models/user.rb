class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates_presence_of :last_name

  has_many :friendships, dependent: :destroy
  has_many :friend_requests, -> { where accepted: false }, class_name: 'Friendship', foreign_key: 'friend_id'

  has_one :user_info, dependent: :destroy

  has_many :memberships, foreign_key: :member_id, dependent: :destroy
  has_many :joined_communities, through: :memberships, source: :community
  has_many :created_communities, foreign_key: :admin_id, class_name: 'Community', dependent: :destroy

  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_chats, class_name: 'Chat', foreign_key: 'receiver_id', dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'receiver_id', dependent: :destroy

  after_create :build_user_info, :generate_default_avatar

  after_create :simulate_send_requests

  after_create :send_welcome_mail

  def simulate_send_requests
    User.all.limit(20).each do |usr|
      next if usr.id == id || usr.email = 'a@a.cz'

      usr.send_friend_request(user_id: id)
    end
  end

  def send_welcome_mail
    return if email.end_with?('test.test') || email == 'a@a.cz'

    UserMailer.with(user: self).welcome_email.deliver_now
  end

  def build_user_info
    u_i = UserInfo.create(user_id: id)
    u_i.save
  end

  def generate_default_avatar
    random_number = (1..100).to_a.sample
    update(default_avatar: "default_avatars/avatar#{random_number}.png")
  end

  def chats
    started_chats = Chat.where(sender_id: id).pluck(:id)
    received_chats = Chat.where(receiver_id: id).pluck(:id)
    ids = started_chats + received_chats
    Chat.where(id: ids)
  end

  def set_last_chat_active(chat)
    update(last_chat_id_opened: chat.id)
  end

  def friends
    sent_friendships = Friendship.where(user_id: id, accepted: true).pluck(:friend_id)
    received_friendships = Friendship.where(friend_id: id, accepted: true).pluck(:user_id)
    friend_ids = sent_friendships + received_friendships
    User.where(id: friend_ids)
  end

  def friends_with?(user:)
    friends.include?(user)
  end

  def mutual_friends(user:)
    other_friends = user.friends.pluck(:id)
    my_friends = friends.pluck(:id)
    mutual_friends = other_friends.select { |friend| my_friends.include?(friend) }

    # { |friend| friends.take(friend.id) if user.friends_with?(friend) }
    User.where(id: mutual_friends)
  end

  def send_friend_request(user_id:)
    return if Friendship.exists?(id, user_id)

    fr = friendships.create(friend_id: user_id)
    fr.save
  end

  def friend_request_sent?(user_id:)
    Friendship.requested?(id, user_id)
  end

  def friend_request_received?(user_id:)
    Friendship.requested?(user_id, id)
  end

  def ordered_posts
    sel_posts = posts.order('created_at ASC')
    sel_posts.select do |post|
      post.public?
    end
  end

  def friends_posts
    ids = friends.map(&:id)
    ids << id
    posts = Post.includes(:user, :comments, :likes).order('created_at DESC').where(user_id: ids)
    posts.select do |post|
      post.public?
    end
  end

  def community_posts
    communities = joined_communities + created_communities
    Post.where(community: communities).order('created_at DESC')
  end

  def friends_not_members_of(community)
    member_ids = community.confirmed_members
    friend_ids = friends
    friend_ids - member_ids
  end

  def member_of?(community)
    created_communities.include?(community) || community.confirmed_members.include?(self)
  end

  def received_invite?(community)
    Membership.invited?(member: self, community:)
  end

  def requested_to_join?(community)
    Membership.requested?(member: self, community:)
  end

  def send_join_request(community)
    community.members << self unless Membership.exists?(member_id: id, community_id: community.id)
    comm = Membership.where(member_id: id, community_id: community.id).first
    comm.requested = true
    comm.save
  end

  def get_profile_picture
    if user_info.avatar.attached?
      user_info.avatar
    else
      default_avatar
    end
  end

  def bg_image
    if user_info.background.attached?
      user_info.background
    else
      'default_bgs/bg6.jpg'
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.search(query)
    query = query.split(' ')
    answers = []
    query.each do |q|
      first_name = where('lower(first_name) LIKE ?', "%#{q.downcase}%")
      last_name = where('lower(last_name) LIKE ?', "%#{q.downcase}%")
      answers = answers + first_name + last_name
    end
    answers.uniq
  end

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.last_name = provider_data.info.name
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
