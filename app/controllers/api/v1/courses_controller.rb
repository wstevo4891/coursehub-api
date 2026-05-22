module Api
  module V1
    class CoursesController < ApplicationController
      before_action :set_course, only: [ :show, :publish, :unpublish ]

      # ToDo: Add a CoursePolicy
      # before_action -> { authorize @course }, only: [ :show, :publish, :unpublish ]

      rescue_from ActiveRecord::RecordNotFound, with: :course_not_found

      def show
        recent_enrollments_cache_key = "courses/#{@course.id}/recent_enrollments/#{latest_enrollment_timestamp(@course)}"

        response_json = {
          course: Rails.cache.fetch(@course.cache_key_with_version) do
            puts "--- Cache Miss! Generating course fragment for Course##{@course.id} ---"

            {
              id: @course.id,
              title: @course.title,
              description: @course.description
            }
          end,
          recent_enrollments: Rails.cache.fetch(recent_enrollments_cache_key, expires_in: 30.minutes) do
            puts "--- Cache Miss! Generating recent enrollments fragment for Course##{@course.id} ---"

            @course.enrollments.order(created_at: :desc).limit(5).map do |enrollment|
              {
                id: enrollment.id,
                enrolled_at: enrollment.created_at,
                user_name: enrollment.user.name
              }
            end
          end
        }

        render json: response_json, status: :ok
      end

      # ToDo: Move #publish and #unpublish to a Courses::PublicationsController
      #       as #create and #destroy
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

      # ToDo: Move #drafts to a Courses::DraftsController as #index
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

      def latest_enrollment_timestamp(course)
        course.enrollments.maximum(:updated_at)&.utc&.to_fs(:usec) || "none"
      end
    end
  end
end
