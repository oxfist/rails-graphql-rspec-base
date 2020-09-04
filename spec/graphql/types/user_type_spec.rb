require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do
  describe 'users query' do
    it 'lists all users' do
      user = FactoryBot.create(:user)
      user_attributes = %w[id name email]
      users_query = <<~GQL
        {
          users {
            id
            email
            name
          }
        }
      GQL

      run_graphql_query(users_query)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to include('data')
      expect(json_response['data']).to include('users')
      first_user = json_response['data']['users'].first
      expect(first_user).not_to be_nil
      expect(first_user.keys).to match_array(user_attributes)
      expect(first_user['id']).to eq(user.id.to_s)
    end

    it 'returns a single user from its id' do
      user = FactoryBot.create(:user)
      user_attributes = %w[id name email]

      user_query = <<~GQL
        {
          user(id: #{user.id}) {
            id
            email
            name
          }
        }
      GQL

      run_graphql_query(user_query)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to include('data')
      expect(json_response['data']).to include('user')
      actual_user = json_response['data']['user']
      expect(actual_user).not_to be_nil
      expect(actual_user.keys).to match_array(user_attributes)
      expect(actual_user['id']).to eq(user.id.to_s)
    end

    # TODO: Add test for single user query when not found

    # TODO: Move to helper
    def run_graphql_query(query)
      post '/graphql', params: { query: query }
    end
  end
end
