class Team < ActiveRecord::Base

  ### Modules ###

  ### Constants ###

  ### Relations ###

  has_many :team_users
  has_many :users, :through => :team_users
  has_many :messages

  ### Scopes ###

  scope :alphabetical, order("LOWER(name) ASC")

  ### Validations ###

  validates :name, presence: true, uniqueness: true

  ### Callbacks ###

  after_create -> { TeamUser.create :team_id => id, :user_id => leader_id }

  ### Miscellaneous ###

  ### Methods ###

  def current_messages
    Message.current_team(self.id).order("created_at DESC")
  end

  def to_s
    name
  end

end
