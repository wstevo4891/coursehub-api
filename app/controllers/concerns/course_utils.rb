# frozen_string_literal: true

module CourseUtils
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :course_not_found
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_not_found
    render json: { error: "Course not found" }, status: :not_found
  end
end
