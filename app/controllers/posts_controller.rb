class PostsController < ApplicationController
	before_filter :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
	before_filter :auth_user, only: [:edit, :update, :destroy]
	
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
		if @post.update_attributes(params[:post])
			flash[:success] = "Post updated"
			redirect_to user_post_path(@post.user, @post)
		else
			render 'edit'
		end
	end

	def destroy
		@user = Post.find(params[:id]).user
		Post.find(params[:id]).destroy
		flash[:success] = "Post deleted."
		redirect_to @user
	end

	private

		def auth_user
			@post = Post.find(params[:id])
			@user = @post.user
			redirect_to(user_path(@user)) unless current_user?(@user) || current_user.admin?
		end
end
