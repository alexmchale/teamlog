class User < ActiveRecord::Base

  include BCrypt

  acts_as_authentic

  attr_accessible :email

  has_many :team_users
  has_many :teams, :through => :team_users
  has_many :messages

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end
