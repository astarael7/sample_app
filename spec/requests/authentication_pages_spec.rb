require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign In" }

			it { should have_selector('title', text: 'Sign In') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }
		end
	end
end
