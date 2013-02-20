class PostsController < ApplicationController
	before_filter :signed_in_user
	
	def new
		@post = current_user.posts.build if signed_in?
	end

	def create
		@post = current_user.posts.build(params[:post])
		if @post.save
			flash[:success] = "Post created!"
			render 'show'
		else
			render 'new'
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
