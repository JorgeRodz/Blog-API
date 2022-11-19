# frozen_string_literal: true

require 'rails_helper'
require 'byebug' # in order to use byebug in this file

RSpec.describe 'Posts with authentication', type: :request do
  # Create 2 users, each one with 1 post
  let!(:user1) { create(:user) }
  let!(:user1_post) { create(:post, user_id: user1.id) }
  let!(:user2) { create(:user) }
  let!(:user2_post) { create(:post, user_id: user2.id, published: true) }
  let!(:user2_post_draft) { create(:post, user_id: user2.id, published: false) }

  # Authorization: Bearer <token>
  # Create authorization tokens for each user
  let!(:auth_headers_U1) { { Authorization: "Bearer #{user1.auth_token}" } }
  let!(:auth_headers_U2) { { Authorization: "Bearer #{user2.auth_token}" } }

  # Para la prueba de crear un post
  let!(:create_params) { { post: { title: 'title', content: 'content', published: true } } }
  let!(:update_params) { { post: { title: 'title', content: 'content', published: true } } }

  # * ------------------------------ GET /posts/{id} - SHOW ------------------------------
  describe 'GET /posts/{id}' do
    context 'with valid authentication' do
      context "when requiresting other's author post" do
        context 'when post is public' do
          before { get "/posts/#{user2_post.id}", headers: auth_headers_U2 }
          # payload
          context 'payload' do
            subject { payload }
            it { is_expected.to include(:id) }
          end
          # response
          context 'response' do
            subject { response }
            it { is_expected.to have_http_status(:ok) }
          end
        end

        context 'when post is a draft' do
          before { get "/posts/#{user2_post_draft.id}", headers: auth_headers_U1 }
          # payload
          context 'payload' do
            subject { payload }
            it { is_expected.to include(:error) }
          end
          # response
          context 'response' do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
          end
        end
      end

      context 'when requesting user own post - no matter is public or a draft' do
        before { get "/posts/#{user2_post_draft.id}", headers: auth_headers_U2 }
        # payload
        context 'payload' do
          subject { payload }
          it { is_expected.to include(:id) }
          it { expect(payload['published']).to eq false }
        end
        # response
        context 'response' do
          subject { response }
          it { is_expected.to have_http_status(:ok) }
        end
      end
    end
  end

  # * ------------------------------ POST /posts - CREATE ------------------------------
  describe 'POST /posts/{id}' do
    # * ----- con auth -> crear -----
    context 'with valid auth' do
      before { post '/posts', params: create_params, headers: auth_headers_U1 }
      # payload
      context 'payload' do
        subject { payload }
        it { is_expected.to include(:id, :title, :content, :published, :author) }
      end
      # response
      context 'response' do
        subject { response }
        it { is_expected.to have_http_status(:created) }
      end
    end
    # * -----  sin auth -> !crear -> 401 -----
    context 'without auth' do
      before { post '/posts', params: create_params }
      # payload
      context 'payload' do
        subject { payload }
        it { is_expected.to include(:error) }
      end
      # response
      context 'response' do
        subject { response }
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end

  # * ------------------------------ PUT /posts - UPDATE ------------------------------
  describe 'PUT /posts/{id}' do
    # * -----  con auth -> actualizar -----
    context 'with valid auth' do
      # * actualizar un post nuestro
      context "when updating user's post" do
        before { put "/posts/#{user1_post.id}", params: update_params, headers: auth_headers_U1 }
        # payload
        context 'payload' do
          subject { payload }
          it { is_expected.to include(:id, :title, :content, :published, :author) }
          it { expect(payload[:id]).to eq(user1_post.id) }
        end
        # response
        context 'response' do
          subject { response }
          it { is_expected.to have_http_status(:ok) }
        end
      end

      # * !actualizar un post de otro -> 401
      context "when updating other user's post" do
        before { put "/posts/#{user2_post.id}", params: update_params, headers: auth_headers_U1 }
        # payload
        context 'payload' do
          subject { payload }
          it { is_expected.to include(:error) }
        end
        # response
        context 'response' do
          subject { response }
          it { is_expected.to have_http_status(:not_found) }
        end
      end
    end
    # * -----  sin auth -> !actualizar -> 401 -----
    context 'without auth' do
      before { put "/posts/#{user1_post.id}", params: update_params }
      # payload
      context 'payload' do
        subject { payload }
        it { is_expected.to include(:error) }
      end
      # response
      context 'response' do
        subject { response }
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end

  private

  # In order to get the payload from the response AKA the JSON body
  def payload
    # 'with_indifferent_access' will allow us to access the hash keys as symbols or strings
    # So we can use 'payload[:id]' or 'payload['id']'
    JSON.parse(response.body).with_indifferent_access
  end
end
