class User < ActiveRecord::Base
  attr_accessible :email
  has_many :team_users
  has_many :teams, :through => :team_users
  has_many :messages
end
