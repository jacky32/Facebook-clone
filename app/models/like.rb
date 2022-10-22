class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  validates :likeable_id, uniqueness: true
end
