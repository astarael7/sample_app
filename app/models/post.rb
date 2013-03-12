# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  attr_accessible :content, :title
  belongs_to :user
  has_many :comments

  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true

  default_scope order: 'posts.created_at DESC'
end
