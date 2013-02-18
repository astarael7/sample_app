class Micropost < ActiveRecord::Base
  attr_accessible :contents
  belongs_to :user

  validates :user_id, presence: true
end
