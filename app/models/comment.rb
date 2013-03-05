class Comment < ActiveRecord::Base
  attr_accessible :content, :post_id, :author
  validates :author, presence: true
  validates :post_id, presence: true
end
