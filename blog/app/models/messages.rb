class Messages < ActiveRecord::Base
  attr_accessible :message, :title, :secret
end
