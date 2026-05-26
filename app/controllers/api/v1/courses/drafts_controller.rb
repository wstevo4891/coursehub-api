# frozen_string_literal: true

module Api
  module V1
    module Courses
      class DraftsController < ApplicationController
        def index
          @drafts = Course.drafts
          render json: @drafts, status: :ok
        end
      end
    end
  end
end
