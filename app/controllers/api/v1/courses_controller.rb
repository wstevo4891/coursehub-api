module Api
  module V1
    class CoursesController < ApplicationController
      include CourseUtils

      before_action :set_course, only: [ :show ]

      # ToDo: Add a CoursePolicy
      # before_action -> { authorize @course }, only: [ :show, :publish, :unpublish ]

      def index
        results = CoursesApi.search_courses(search_params)
        render json: results, status: :ok
      end

      def show
        serializer = CourseSerializer.new(@course)

        response_json = {
          course: serializer.as_json_cached,
          recent_enrollments: serializer.recent_enrollments_json_cached
        }

        render json: response_json, status: :ok
      end

      private

      def search_params
        {
          pagination: params.permit(:page, :per_page),
          query: params.permit(:status, :recent, :enrollments, :sort)
        }
      end
    end
  end
end
