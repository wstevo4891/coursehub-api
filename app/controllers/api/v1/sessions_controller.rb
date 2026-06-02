module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        @user = User.find_by(email: params[:email])

        if @user&.authenticate(params[:password])
          @user.refresh_tokens.destroy_all

          json_response = TokenSerializer.call(@user)

          render json: json_response, status: :ok
        else
          render json: {
            error: {
              code: "invalid_attributes",
              message: "Invalid email or password"
            }
          }, status: :unauthorized
        end
      end
    end
  end
end
