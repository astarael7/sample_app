class PostsController < ApplicationController
  def new
  end

  def show
  	@post = Post.find(params[:id])
  end
end
