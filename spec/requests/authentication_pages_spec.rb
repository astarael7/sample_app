require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign In" }

			it { should have_title('Sign In') }
			it { should have_error_message('Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message('') }
			end
		end

		describe "with valid information" do
			let (:user) { FactoryGirl.create(:user) }
			before { sign_in user  }
			it { should have_signed_in user }
			it { should_not have_link('Sign In', href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign Out" }
				it { should have_link('Sign In') }
			end
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			let(:post) { FactoryGirl.create(:post) }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path user
					sign_in user
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						page.should have_selector('title', text: 'Edit user')
					end

					describe "when signing in again" do
						before do
							delete signout_path
							visit signin_path
							sign_in user
						end

						it "should render the default (profile) page" do
							page.should have_title(user.name)
						end
					end
				end
			end

			shared_examples_for "submitting any forbidden request" do
				it { should redirect_to(signin_path) }
			end

			shared_examples_for "visiting any forbidden page" do
				it { should have_selector('title', text: 'Sign In') }
			end

			describe "in the Posts controller" do

				describe "visiting a post" do
					before { visit user_post_path(user, post) }
					it_should_behave_like "visiting any forbidden page"
				end

				describe "visiting the edit post page" do
					before { visit edit_user_post_path(user, post) }
					it_should_behave_like "visiting any forbidden page"
				end

				describe "visiting the new post page" do
					before { visit new_user_post_path(user) }
					it_should_behave_like "visiting any forbidden page"
				end

				describe "submitting a PUT request" do
					before { put user_post_path(user, post) }
					it_should_behave_like "submitting any forbidden request"
				end

				describe "submitting a DELETE request" do
					before { delete user_post_path(user, post) }
					it_should_behave_like "submitting any forbidden request"
				end
			end

			describe "in the Users controller" do

				describe "visiting a user" do
					before { visit user_path(user) }
					it_should_behave_like "visiting any forbidden page"
				end

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it_should_behave_like "visiting any forbidden page"
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					it_should_behave_like "submitting any forbidden request"
				end

				describe "visiting the user index" do
					before { visit users_path }
					it_should_behave_like "visiting any forbidden page"
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Edit user')) }
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as a non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end
end
