module Api
  module V1
    class CoursesController < ApplicationController
      include CourseUtils

      before_action :set_course, only: [ :show ]

      # ToDo: Add a CoursePolicy
      # before_action -> { authorize @course }, only: [ :show, :publish, :unpublish ]

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

      private

      def latest_enrollment_timestamp(course)
        course.enrollments.maximum(:updated_at)&.utc&.to_fs(:usec) || "none"
      end
    end
  end
end
