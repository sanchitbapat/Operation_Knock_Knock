class Register < ActiveRecord::Base
  attr_accessible :password, :username, :password_confirm, :loginflag, :knock1, :knock2, :knock3, :knock4
  validates :username, presence: true
  validates :password, presence: true
  validates_confirmation_of :password
  validates_uniqueness_of :username
end
