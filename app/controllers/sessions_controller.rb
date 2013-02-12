class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# Sign in the user and redirect to the user's page.
		else
			# Create an error message and re-render the signin form.
		end
	end

	def destroy
	end
end
