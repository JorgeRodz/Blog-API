# frozen_string_literal: true

require 'rails_helper'
require 'byebug' # in order to use byebug in this file

RSpec.describe 'Posts', type: :request do
  #------------------------------ GET /posts - INDEX ------------------------------
  describe 'GET /posts' do
    describe 'with no data in the DB' do
      it 'should return empty data and status 200-OK' do
        get '/posts' # GET /posts - INDEX

        payload = JSON.parse(response.body)       # to optain the JSON response body
        expect(payload).to be_empty               # JSON response be empty
        expect(response).to have_http_status(200) # HTTP response status code 200
      end
    end

    describe 'with data in the DB' do
      # rspec-core hook - # factory_bot_rails
      let!(:posts) { create_list(:post, 10, published: true) } # create 10 posts in the DB
      # Here we use the let! keyword to force the creation of the posts before the test

      it 'should return all the published posts and status 200-OK' do
        get '/posts' # GET /posts - INDEX

        payload = JSON.parse(response.body)       # to optain the JSON response body
        expect(payload.size).to eq(posts.size)    # JSON response size should be equal to the number of posts in the DB
        expect(response).to have_http_status(200) # HTTP response status code 200
      end
    end
  end

  #------------------------------ GET /posts/{id} - SHOW ------------------------------
  describe 'GET /posts/{id}' do
    # rspec-core hook - # factory_bot_rails
    let!(:post) { create(:post) } # create a post
    # Here we use the let! keyword to force the creation of the posts before the test

    it 'should return a post and status 200-OK' do
      get "/posts/#{post.id}" # make a GET request to /posts/{id}

      payload = JSON.parse(response.body)       # to optain the JSON response body
      expect(payload).not_to be_empty           # JSON response not_to be empty
      # The payload(JSON response body) should contain all the keys listed below
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq(post.published)
      expect(payload['author']['name']).to eq(post.user.name)
      expect(payload['author']['email']).to eq(post.user.email)
      expect(payload['author']['id']).to eq(post.user.id)
      expect(response).to have_http_status(200) # HTTP response status code 200
    end

    it 'should return a "404-Not Found" status code' do
      get '/posts/1000' # make a GET request to /posts/{id}

      payload = JSON.parse(response.body) # to optain the JSON response body
      expect(payload['error']).not_to be_empty # JSON response should contain a key 'id'
      expect(response).to have_http_status(404) # HTTP response status code 404
    end
  end

  #------------------------------ POST /posts - CREATE ------------------------------
  describe 'POST /posts' do
    let!(:user) { create(:user) } # create a user first in order to create a post

    it 'should create a post' do
      # JSON information of our new post
      req_payload = {
        post: {
          title: 'title',
          content: 'content',
          published: false,
          user_id: user.id # we use the id of the previously created user
        }
      }

      # POST HTTP request to /posts
      post '/posts', params: req_payload

      payload = JSON.parse(response.body)            # to optain the JSON response body
      expect(payload).not_to be_empty                # JSON response not_to be empty
      expect(payload['id']).not_to be_nil            # JSON response 'id' key should not be_nil
      expect(response).to have_http_status(:created) # HTTP response status code 201
    end

    it 'should return error message on invalid post creation' do
      # JSON invalid information
      req_payload = {
        post: {
          title: '',
          content: 'content',
          published: false,
          user_id: user.id # we use the id of the previously created user
        }
      }

      # POST HTTP request to /posts
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)            # to optain the JSON response body
      expect(payload).not_to be_empty                # JSON response not_to be empty
      expect(payload['error']).not_to be_empty       # JSON response should contain a key 'id'
      expect(response).to have_http_status(:unprocessable_entity) # HTTP response status code 422
    end
  end

  #------------------------------ PUT /posts/{id} - CREATE ------------------------------
  describe 'PUT /posts/{id}' do
    let!(:article) { create(:post) } # create a post first in order to update(edit) it
    # Here we call it article

    it 'should update a post' do
      # JSON information to update our post
      req_payload = {
        post: {
          title: 'title',
          content: 'content',
          published: true
        }
        # No need to pass the user_id because it is not editable
      }

      # PUT HTTP request
      put "/posts/#{article.id}", params: req_payload # making the request a passing the previous information JSON

      payload = JSON.parse(response.body)            # to optain the JSON response body
      expect(payload).not_to be_empty                # JSON response not_to be empty
      expect(payload['id']).not_to be_nil            # JSON response 'id' key should not be_nil
      expect(response).to have_http_status(:ok) # HTTP response status code 201
    end

    it 'should return a "404-Not Found" status code' do
      put '/posts/1000' # make a PUT request to /posts/{id}, so in this case this post does not exist

      payload = JSON.parse(response.body) # to optain the JSON response body
      expect(payload['error']).not_to be_empty # JSON response should contain a key 'id'
      expect(response).to have_http_status(404) # HTTP response status code 404
    end

    it 'should return error message on invalid post update' do
      # JSON invalid information
      req_payload = {
        post: {
          title: '',
          content: '',
          published: false
        }
      }

      # PUT HTTP request to /posts
      put "/posts/#{article.id}", params: req_payload # making the request a passing the previous information JSON

      payload = JSON.parse(response.body)            # to optain the JSON response body
      expect(payload).not_to be_empty                # JSON response not_to be empty
      expect(payload['error']).not_to be_empty       # JSON response should contain a key 'id'
      expect(response).to have_http_status(:unprocessable_entity) # HTTP response status code 422
    end
  end
end
