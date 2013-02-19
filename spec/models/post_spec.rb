require 'spec_helper'

describe Post do

  let(:user) { FactoryGirl.create(:user) }
  before { @post = user.posts.build(title: "Lorem ipsum", content: "dolor sit amet") }

  subject { @post }

  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
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
end
