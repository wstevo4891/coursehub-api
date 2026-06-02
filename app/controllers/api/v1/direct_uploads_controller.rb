# frozen_string_literal: true

module Api
  module V1
    class DirectUploadsController < ApplicationController
      before_action :authorize_request

      rescue_from ActiveSupport::MessageVerifier::InvalidSignature,
                  with: :handle_invalid_signature

      def create
        json_response = BlobSerializer.call(blob_params, @current_user.id)

        render json: json_response, status: :ok
      end

      private

      def blob_params
        params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type)
      end

      def handle_invalid_signature
        render json: {
          error: {
            code: "invalid_signature",
            message: "Invalid checksum or parameters."
          }
        }, status: :unprocessable_entity
      end
    end
  end
end
