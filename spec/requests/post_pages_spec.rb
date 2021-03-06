require 'spec_helper'

describe "Post pages" do
	
	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user, email: "other@example.com") }
	let(:admin) { FactoryGirl.create(:admin) }
	let!(:post) { FactoryGirl.create(:post, user: user) }
	before { sign_in user }

	describe "post creation" do
		before { visit new_user_post_path(user) }

		describe "with invalid information" do
			
			it "should not create a post" do
				expect { click_button "Post" }.not_to change(Post, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			
			before do
				fill_in "post_title",	with: "Lorem Ipsum"
				fill_in "post_content",	with: "Dolor sit amet"
			end

			it "should create a post" do
				expect { click_button "Post" }.to change(Post, :count).by(1)
			end
		end
	end

	describe "viewing a post" do
		before { visit user_post_path(user, post) }

		it "should display the post" do
			page.should have_content(post.title)
			page.should have_content(post.content)
		end

		describe "as owner" do
			it { should have_link('Edit', href: edit_user_post_path(user, post)) }
			it { should have_link('Delete', href: user_post_path(user, post)) }
		end

		describe "as other user" do
			before do
				sign_in other_user
				visit user_post_path(user, post)
			end

			it { should_not have_link('Edit', href: edit_user_post_path(user, post)) }
			it { should_not have_link('Delete', href: user_post_path(user, post)) }
		end

		describe "as admin" do
			before do
			  sign_in admin
			  visit user_post_path(user, post)
			end

			it { should have_link('Edit', href: edit_user_post_path(user, post)) }
			it { should have_link('Delete', href: user_post_path(user, post)) }
		end
	end

	describe "edit" do
		before do
		  sign_in user
		  visit edit_user_post_path(user, post)
		end
		
		describe "page" do
			it { should have_selector('h1', text: "Update Your Post") }
			it { should have_selector('title', text: "Edit Post") }
		end

		describe "with invalid changes" do
			before do
				fill_in "post_title", 	with: ''
				fill_in "post_content",	with: ''
				click_button "Save Changes"
			end

			it { should have_content('error') }
		end

		describe "with valid changes" do
			let(:new_title) { "New Title" }
			let(:new_content) { "New content" }
			before do
				fill_in "post_title", 	with: new_title
				fill_in "post_content",	with: new_content
				click_button "Save Changes"
			end

			it { should have_content(new_title) }
			it { should have_content(new_content) }

			specify { post.reload.title == new_title }
			specify { post.reload.content == new_content }
		end
	end
end