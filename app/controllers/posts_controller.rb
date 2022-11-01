# frozen_string_literal: true

class PostsController < ApplicationController
  # ---------- Handling Exceptions ----------
  # ℹ️ Is import to prioritize the exceptions in the order of the most general to the most specific ℹ️

  # In order to manage generic Exceptions
  rescue_from Exception do |e|
    render json: { error: e.message }, status: :internal_error
  end

  # In order to manage a response when an record is invalid
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # In order to manage a response when an record is not found
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end
  # ---------- Handling Exceptions ----------

  # POST /posts
  def create
    @post = Post.create!(create_params) # Here the 'create!' method will raise a 'RecordInvalid' if the record is invalid, this way we can handle the exception in the 'rescue_from' block
    render json: @post, status: :created
  end

  # GET /posts/
  def index
    @posts = Post.where(published: true)
    render json: @posts, status: :ok
  end

  # GET /posts/{id}
  def show
    @post = Post.find(params[:id]) # In the case the record is not found....'find' will raise a 'RecordNotFound' exception, this way we can handle the exception in the 'rescue_from' block
    render json: @post, status: :ok
  end

  # PUT /posts/{id}
  def update
    @post = Post.find(params[:id]) # same case as 'show' method
    @post.update!(update_params) # Here the 'update!' method will raise a 'RecordInvalid' if the record is invalid, this way we can handle the exception in the 'rescue_from' block
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end
