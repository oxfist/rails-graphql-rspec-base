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
      json = JSON.parse(response.body)
      first_user = json['data']['users'].first
      expect(first_user).not_to be_nil
      expect(first_user.keys).to match_array(user_attributes)
    end

    # TODO: Move to helper
    def run_graphql_query(query)
      post '/graphql', params: { query: query }
    end
  end
end
