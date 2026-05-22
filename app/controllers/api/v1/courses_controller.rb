module Api
  module V1
    class CoursesController < ApplicationController
      before_action :set_course, only: [ :publish, :unpublish ]

      rescue_from ActiveRecord::RecordNotFound, with: :course_not_found

      def publish
        if @course.publish!
          render json: @course, status: :ok
        else
          render json: { errors: "Could not publish course" }, status: :unprocessable_content
        end
      end

      def unpublish
        if @course.unpublish!
          render json: @course, status: :ok
        else
          render json: { errors: "Could not unpublish course" }, status: :unprocessable_content
        end
      end

      def drafts
        @draft_courses = Course.drafts

        render json: @draft_courses, status: :ok
      end

      private

      def set_course
        @course = Course.find(params[:id])
      end

      def course_not_found
        render json: { error: "Course not found" }, status: :not_found
      end
    end
  end
end
