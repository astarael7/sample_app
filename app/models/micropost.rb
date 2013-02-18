class Micropost < ActiveRecord::Base
  attr_accessible :contents
  validates :user_id, presence: true
end
