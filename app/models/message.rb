class Message < ActiveRecord::Base

  belongs_to :team_user

  delegate :user, :to => :team_user
  delegate :team, :to => :team_user

  validates :user, presence: true, associated: true

  scope :newest_first, -> { order("created_at DESC") }
  scope :current_team, -> team_id { select("DISTINCT ON (user_id) *").where(:team_id => team_id).order("user_id, created_at DESC") }

end
