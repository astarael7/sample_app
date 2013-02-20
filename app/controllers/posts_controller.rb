class PostsController < ApplicationController
	before_filter :signed_in_user
	
	def new
	end

	def create
		@post = current_user.posts.build(params[:post])
		if @post.save
			flash[:success] = "Post created!"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end

	def show
		@post = Post.find(params[:id])
	end

	def edit
	end

	def update
	end

	def destroy
	end
end
