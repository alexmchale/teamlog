class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  attr_accessible :content
end
