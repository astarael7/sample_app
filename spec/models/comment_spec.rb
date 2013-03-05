require 'spec_helper'

describe Comment do
	let(:user) { FactoryGirl.create(:user) }
	let!(:post) { FactoryGirl.create(:post, user: user) }

	before do
		@comment = post.comments.build(content: "Lorem ipsum", author:user.name)
	end

	subject { @comment }

	it { should respond_to(:content) }
	it { should respond_to(:author) }
	it { should respond_to(:post_id) }

	it { should be_valid }

	describe "when author is not present" do
		before { @comment.author = nil }
		it { should_not be_valid }
	end

	describe "when post id is not present" do
		before { @comment.post_id = nil }
		it { should_not be_valid }
	end
end
