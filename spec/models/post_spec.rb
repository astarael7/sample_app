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

require 'spec_helper'

describe Post do

  let(:user) { FactoryGirl.create(:user) }
  before { @post = user.posts.build(title: "Lorem ipsum", content: "dolor sit amet") }

  subject { @post }

  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:comments) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user id" do
      expect do
        Post.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user id is not present" do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @post.title = '' }
    it { should_not be_valid }
  end

  describe "when content is not present" do
    before { @post.content = ''}
    it { should_not be_valid }
  end

  describe "comment associations" do
    
    before { @post.save }
    let!(:older_comment) do
      FactoryGirl.create(:comment, post: @post, created_at: 1.day.ago)
    end
    let!(:newer_comment) do
      FactoryGirl.create(:comment, post: @post, created_at: 1.hour.ago)
    end

    it "should have the right comments in the right order" do
      @post.comments.should == [newer_comment, older_comment]
    end
  end
end
