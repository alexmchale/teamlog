class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :team

  validates :user, presence: true, associated: true

  scope :newest_first, order("created_at DESC")

end
