require 'spec_helper'

describe "User pages" do
	subject { page }

	describe "index" do
		
		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_title('All users') }

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all) { User.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li', text: user.name)
				end
			end
		end

		describe "edit and delete links" do
			it { should_not have_link('Edit') }
			it { should_not have_link('Delete') }

			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit users_path
				end
				
				it { should have_link('Delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('Delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('Delete', href: user_path(admin)) }
			end
		end
	end

	describe "visiting profile page" do
		let(:admin) { FactoryGirl.create(:admin) }
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user, email: "other@example.com") }
		let!(:post) { FactoryGirl.create(:post, user: user, title: "Foo", content: "bar") }

		describe "as signed-in user" do
			before do
				sign_in user
				visit user_path user
			end
			
			it { should have_title(user.name) }
			it { should have_link('New Post') }
			it { should have_link("#{post.title}") }
			it { should have_link('Edit', href: edit_user_post_path(user, post)) }
			it { should have_link('Delete', href: user_post_path(user, post)) }
			it { should have_content(user.posts.count) }
		end

		describe "as another user" do
			before do
				sign_in other_user
				visit user_path user
			end

			it { should_not have_link('New Post') }
			it { should have_link("#{post.title}") }
			it { should_not have_link('Edit', href: edit_user_post_path(user, post)) }
			it { should_not have_link('Delete', href: user_post_path(user, post)) }
		end

		describe "as an admin" do
			before do
				sign_in admin
				visit user_path user
			end

			it { should have_link('Edit', href: edit_user_post_path(user, post)) }
			it { should have_link('Delete', href: user_post_path(user, post)) }
		end
	end

	describe "visit signup page" do

		describe "as a signed-in user" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				visit signup_path
			end

			it { should_not have_title('Sign up') }
		end


		before { visit signup_path }

		it { should have_title('Sign up') }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_title('Sign up') }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before { valid_signup }

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by_email('example@mail.com') }
				it { should have_loaded_user_page(user) }
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_selector('h1', text: 'Update your profile') }
			it { should have_selector('title', text: 'Edit user') }
			it { should have_link('Change', href: 'http://gravatar.com/emails') }
		end

		describe "with invalid information" do
			before { click_button "Save changes" }
			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			let(:new_email) { "new@example.com" }

			before do
				fill_in "Name", 			with: new_name
				fill_in "Email",			with: new_email
				fill_in "Password",			with: user.password
				fill_in "Confirm Password",	with: user.password
				click_button "Save changes"
			end

			it { should have_title(new_name) }
			it { should have_link('Sign Out', href: signout_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email }
		end
	end
end
