module Api
  module V1
    class CoursesController < ApplicationController
      include CourseUtils

      before_action :set_course, only: [ :show, :update, :destroy ]

      before_action -> { authorize @course }, only: [ :show, :update, :destroy ]

      def index
        response_json = CoursesApi.search_courses(search_params)
        render json: response_json, status: :ok
      end

      def show
        serializer = CourseSerializer.new(@course)

        response_json = {
          course: serializer.as_json_cached,
          recent_enrollments: serializer.recent_enrollments_json_cached
        }

        render json: response_json, status: :ok
      end

      def create
        authorize Course
        @course = Course.new(course_params_without_attachment)

        attach_video_blob

        if @course.save
          render json: course_json, status: :created
        else
          render json: error_json, status: :unprocessable_entity
        end
      end

      def update
        if @course.update(course_params_without_attachment)

          attach_video_blob

          render json: course_json, status: :ok
        else
          render json: error_json, status: :unprocessable_entity
        end
      end

      def destroy
        @course.destroy
        head :no_content
      end

      private

      def search_params
        {
          pagination: params.permit(:page, :per_page),
          query: params.permit(:status, :recent, :enrollments, :sort)
        }
      end

      def course_params_without_attachment
        params.require(:course).permit(:title, :description)
      end

      def attach_video_blob
        return unless params.dig(:course, :video_blob_signed_id).present?

        @course.video.attach(params[:course][:video_blob_signed_id])
      rescue Active::Support::MessageVerifier::InvalidSignature
        @course.errors.add(:video, "attachment signature is invalid")
      end

      def course_json
        {
          course: CourseSerializer.call(@course),
          location: api_v1_course_url(@course)
        }
      end

      def error_json
        {
          error: {
            code: "invalid_parameters",
            message: "Invalid parameters for course."
          }
        }
      end
    end
  end
end
