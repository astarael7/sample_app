require 'spec_helper'

describe "Posts" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let!(:p1) { FactoryGirl.create(:post, user: user, title: "Foo", content: "bar") }

	before do
		sign_in user
		visit user_post_path(user, p1)
	end
	
	it { should have_title(p1.title) }
	it { should have_content(p1.content) }
	it { should have_content(p1.user.name) }
end