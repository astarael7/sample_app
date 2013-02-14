include ApplicationHelper

def sign_in(user)
	fill_in "Email",	with: user.email.upcase
	fill_in "Password",	with: user.password
	click_button "Sign In"
	# Sign in when not using Capybara as well.
	cookies[:remember_token] = user.remember_token
end

def valid_signup
	fill_in "Name",				with: "Example Name"
	fill_in "Email",			with: "example@mail.com"
	fill_in "Password",			with: "foobar"
	fill_in "Confirm Password",	with: "foobar"
end

Rspec::Matchers.define :have_title do |title|
	match do |page|
		page.should have_selector('h1', text: title)
		page.should have_selector('title', text: title)
	end
end


RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end

RSpec::Matchers.define :have_loaded_user_page do |user|
	match do |page|
		page.should have_selector('title', name: user.name)
		page.should have_selector('div.alert.alert-success', text: 'Welcome')
		page.should have_link('Sign Out')
	end
end

RSpec::Matchers.define :have_signed_user_in do |user|
	match do |page|
		page.should have_selector('title', text: user.name)
		page.should have_link('Profile', href: user_path(user))
		page.should have_link('Settings', href: edit_user_path(user))
		page.should have_link('Sign Out', href: signout_path)
		page.should_not have_link('Sign In', href: signin_path)
	end
end