class User < ActiveRecord::Base

  include BCrypt

  has_many :team_users
  has_many :teams, :through => :team_users
  has_many :messages

  validates :email, :presence => true, :email => true, :uniqueness => true
  validates :first_team_name, :presence => true, :length => { :maximum => 30 }, :on => :create, :unless => :skip_new_team
  validate -> { errors[:password] << "must be at least 4 characters in length" if @new_password_length && @new_password_length < 4 }

  before_validation -> { self.email = email.to_s.strip }
  before_save -> { self.secret_code ||= Digest::SHA1.hexdigest([ Time.now, rand ].join) }
  after_create -> { Team.create! :name => first_team_name, :leader_id => self.id if first_team_name.present? && !skip_new_team }

  attr_reader :new_password_length
  attr_accessor :first_team_name
  attr_accessor :skip_new_team

  def password
    @password ||= Password.new(password_hash) if password_hash != nil
  end

  def password=(new_password)
    @new_password_length = new_password.length
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def add_to_team(team)
    return if team == nil
    return if new_record?

    TeamUser.create! team_id: team.id, user_id: self.id
  end

  def to_s
    email
  end

  def grant_new_secret_code!
    self.secret_code = Digest::SHA1.hexdigest([ Time.now, rand ].join)
    self.save!
  end

  def self.find_by_email(email)
    where("LOWER(email) = ?", email.to_s.downcase).first if email.present?
  end

end
