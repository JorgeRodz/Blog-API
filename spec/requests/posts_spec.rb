# frozen_string_literal: true

require 'rails_helper'
require 'byebug' # in order to use byebug in this file

RSpec.describe 'Posts', type: :request do
  #------------------------------ GET /posts - INDEX tests ------------------------------
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

  #------------------------------ GET /posts/{id} - SHOW tests ------------------------------
  describe 'GET /posts/{id}' do
    # rspec-core hook - # factory_bot_rails
    let!(:post) { create(:post) } # create a post
    # Here we use the let! keyword to force the creation of the posts before the test

    it 'should return a post and status 200-OK' do
      get "/posts/#{post.id}" # make a GET request to /posts/{id}

      payload = JSON.parse(response.body)       # to optain the JSON response body
      expect(payload).not_to be_empty           # JSON response not_to be empty
      expect(payload['id']).to eq(post.id)      # JSON response id should be equal to the post id
      expect(response).to have_http_status(200) # HTTP response status code 200
    end

    it 'should return a "404-Not Found" status code' do
      get '/posts/1000' # make a GET request to /posts/{id}

      payload = JSON.parse(response.body) # to optain the JSON response body
      expect(payload['message']).to eq('Post not found') # JSON response should contain a key 'message' with the string 'Post not found'
      expect(response).to have_http_status(404) # HTTP response status code 404
    end
  end
end
