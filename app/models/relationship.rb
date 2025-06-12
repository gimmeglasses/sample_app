class Relationship < ApplicationRecord
  # these belongs_to methods build associations between 
  # the Relationship model and the User model
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
