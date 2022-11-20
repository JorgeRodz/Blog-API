# frozen_string_literal: true

class PostsController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: %i[create update show]
  # skip_before_action :authenticate_user!, only: %i[show], unless: :post_published?

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
    # Here we create a post using the current logged user, this is posible because we have a relationship between the -
    # - 'Post' and 'User' models
    @post = Current.user.posts.create!(create_params) # Here the 'create!' method will raise a 'RecordInvalid' if the record is invalid, this way we can handle the exception in the 'rescue_from' block
    render json: @post, status: :created
  end

  # GET /posts/
  def index
    @posts = Post.where(published: true)

    # If the query param is present, we will search for posts with the query string
    # Here we call the 'search' method from the 'PostsSearchService' class if the 'query' param is present on the request
    # We pass the 'current published posts' and the 'search' param in order to look for the posts that match the search param
    @posts = PostsSearchService.search(@posts, params[:search]) if !params[:search].nil? && params[:search].present?

    render json: @posts.includes(:user), status: :ok # here we use the 'includes' method to avoid the N+1 problem
  end

  # GET /posts/{id}
  # Return only published posts or posts that belongs to the current logged user
  def show
    @post = Post.find(params[:id]) # In the case the record is not found....'find' will raise a 'RecordNotFound' exception, this way we can handle the exception in the 'rescue_from' block
    if @post.published || (Current.user && @post.user_id == Current.user.id)
      render json: @post, status: :ok
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  # PUT /posts/{id}
  def update
    # Find only the posts that belongs to the current logged user
    @post = Current.user.posts.find(params[:id]) # same case as 'show' method
    @post.update!(update_params) # Here the 'update!' method will raise a 'RecordInvalid' if the record is invalid, this way we can handle the exception in the 'rescue_from' block
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end

  def post_published?
    post = Post.find(params[:id])
    post.published
  end
end
