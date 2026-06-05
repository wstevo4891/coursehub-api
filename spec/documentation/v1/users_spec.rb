require "swagger_helper"

RSpec.describe "Users API V1", type: :request do
  let(:user) { create(:user) }
  let(:access_token) { JsonWebToken.encode(user_id: user.id) }

  path "/api/v1/users/{id}" do
    parameter name: :id, in: :path, type: :string, description: "User ID"

    get "Retrieves a user" do
      tags "Users"
      produces "application/json"

      response "200", "user found" do
        schema  type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  email: { type: :string },
                  is_admin: { type: :boolean },
                  created_at: { type: :string, format: "date-time" },
                  updated_at: { type: :string, format: "date-time" }
                },
                required: [ "id", "name", "email", "is_admin" ]

        let(:id) { user.id }
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end

      response "404", "user not found" do
        schema  type: :object,
                properties: {
                  code: { type: :string },
                  message: { type: :string }
                }

        let(:id) { "invalid-id" }
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end
    end
  end
end
