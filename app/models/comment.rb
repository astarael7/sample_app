class Comment < ActiveRecord::Base
  attr_accessible :content, :author
  belongs_to :post

  validates :author, presence: true
  validates :post_id, presence: true
end