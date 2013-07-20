class User < ActiveRecord::Base

  include BCrypt

  has_many :team_users
  has_many :teams, :through => :team_users
  has_many :messages

  validates :email, :presence => true, :email => true, :uniqueness => true

  before_validation -> { self.email = email.to_s.strip }
  before_save -> { self.secret_code ||= Digest::SHA1.hexdigest([ Time.now, rand ].join) }

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def add_to_team(team)
    return if team == nil
    return if new_record?

    TeamUser.create! team_id: team.id, user_id: self.id
  end

  def self.find_by_email(email)
    where("LOWER(email) = ?", email.to_s.downcase).first
  end

end
