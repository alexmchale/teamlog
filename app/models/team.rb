class Team < ActiveRecord::Base

  ### Modules ###

  ### Constants ###

  ### Relations ###

  has_many :team_users
  has_many :users, :through => :team_users
  has_many :messages, :through => :team_users

  ### Scopes ###

  scope :alphabetical, -> { order("LOWER(name) ASC") }

  ### Validations ###

  validates :name, presence: true, uniqueness: true

  ### Callbacks ###

  after_create -> { TeamUser.create :team_id => id, :user_id => leader_id }

  ### Miscellaneous ###

  ### Methods ###

  def current_messages
    Message.current_team(self.id).order("created_at DESC")
  end

  def members_including_most_recent_message
    columns = [
      "team_users.*",
      "messages.created_at AS message_created_at",
      "messages.content AS message_content",
    ]

    team_users =
      TeamUser.
        select("DISTINCT ON (team_users.id) #{columns.join ', '}").
        joins("LEFT JOIN messages ON team_users.id = messages.team_user_id").
        includes(:team, :user).
        where("team_users.team_id = ?", self.id).
        order("team_users.id, messages.created_at DESC").
        to_a

    team_users.sort! do |tu1, tu2|
      if    tu1.message_created_at.blank? then 1
      elsif tu2.message_created_at.blank? then -1
      else  tu2.message_created_at <=> tu1.message_created_at
      end
    end

    team_users
  end

  def to_s
    name
  end

end
