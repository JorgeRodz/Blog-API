# frozen_string_literal: true

class PostsController < ApplicationController
  # GET /posts/
  def index
    @posts = Post.where(published: true)
    render json: @posts, status: :ok
  end

  # GET /posts/{id}
  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Post not found' }, status: :not_found
  end
end
