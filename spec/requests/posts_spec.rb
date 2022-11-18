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

    describe 'with data in the DB - Search Post' do
      # Create three published post with different titles
      let!(:hola_mundo) { create(:published_post, title: 'Hola Mundo') }
      let!(:hola_rails) { create(:published_post, title: 'Hola Rails') }
      let!(:curso_rails) { create(:published_post, title: 'Curso Rails') }

      it 'should filter posts by title' do
        get '/posts?search=Hola' # get request with query params(?search=Hola)

        payload = JSON.parse(response.body)       # to optain the JSON response body
        expect(payload).not_to be_empty           # JSON response have not to be empty
        expect(payload.size).to eq(2)             # JSON response size should be equal to 2
        expect(payload.map { |p| p['id'] }.sort).to eq([hola_mundo.id, hola_rails.id].sort) # JSON response ids should be equal to the ids of the posts with title 'Hola'
        expect(response).to have_http_status(200) # HTTP response status code 200
      end
    end
  end

  #------------------------------ GET /posts/{id} - SHOW ------------------------------
  describe 'GET /posts/{id}' do
    # rspec-core hook - # factory_bot_rails
    let!(:post) { create(:post, published: true) } # create a post
    # Here we use the let! keyword to force the creation of the posts before the test

    it 'should return a post and status 200-OK' do
      get "/posts/#{post.id}" # make a GET request to /posts/{id}

      payload = JSON.parse(response.body)       # to optain the JSON response body
      expect(payload).not_to be_empty           # JSON response not_to be empty
      # The payload(JSON response body) should contain all the keys listed below
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq true
      expect(payload['author']['name']).to eq(post.user.name)
      expect(payload['author']['email']).to eq(post.user.email)
      expect(payload['author']['id']).to eq(post.user.id)
      expect(response).to have_http_status(200) # HTTP response status code 200
    end

    it 'should return a "404-Not Found" status code' do
      get '/posts/1000' # make a GET request to /posts/{id}

      payload = JSON.parse(response.body) # to optain the JSON response body
      expect(payload['error']).not_to be_empty # JSON response should contain an error message
      expect(response).to have_http_status(404) # HTTP response status code 404
    end
  end
end
