class Team < ActiveRecord::Base

  has_many :team_users
  has_many :users, :through => :team_users
  has_many :messages

  scope :alphabetical, order("LOWER(name) ASC")

  validates :name, presence: true, uniqueness: true

  def current_messages
    Message.current_team(self.id)
  end

end
