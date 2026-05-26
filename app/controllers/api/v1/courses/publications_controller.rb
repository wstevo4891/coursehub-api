# frozen_string_literal: true

module Api
  module V1
    module Courses
      class PublicationsController < ApplicationController
        include CourseUtils

        before_action :set_course, only: [ :create, :destroy ]

        def index
          @published_courses = Course.published
          render json: @published_courses, status: :ok
        end

        def create
          if @course.publish!
            render json: @course, status: :ok
          else
            render json: { errors: "Could not publish course" }, status: :unprocessable_content
          end
        end

        def destroy
          if @course.unpublish!
            render json: @course, status: :ok
          else
            render json: { errors: "Could not unpublish course" }, status: :unprocessable_content
          end
        end
      end
    end
  end
end
