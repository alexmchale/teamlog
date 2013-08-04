class TeamUser < ActiveRecord::Base

  belongs_to :team
  belongs_to :user
  has_many :messages

  def messages
    Message.where(:team_id => team_id, :user_id => team_id)
  end

  def self.add_member(team, user)
    attributes = { :team_id => team.id, :user_id => user.id }
    if where(attributes).count == 0
      create(:team_id => team.id, :user_id => user.id)
    end
  end

end
