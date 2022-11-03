class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  after_create_commit -> { broadcast_prepend_to 'notifications' }
  after_destroy_commit -> { broadcast_remove_to 'notifications' }
end
