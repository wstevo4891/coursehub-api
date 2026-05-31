# frozen_string_literal: true

class CourseSerializer
  def self.call(course)
    new(course).as_json
  end

  def initialize(course)
    @course = course
  end

  def as_json
    {
      id: course.id,
      title: course.title,
      description: course.description
    }
  end

  def as_json_cached
    Rails.cache.fetch(course.cache_key_with_version) do
      puts "--- Cache Miss! Generating course fragment for Course##{course.id} ---"
      as_json
    end
  end

  def recent_enrollments_json
    course.enrollments.order(created_at: :desc).limit(5).map do |enrollment|
      {
        id: enrollment.id,
        enrolled_at: enrollment.created_at,
        user_name: enrollment.user.name
      }
    end
  end

  def recent_enrollments_json_cached
    Rails.cache.fetch(recent_enrollments_cache_key, expires_in: 30.minutes) do
      puts "--- Cache Miss! Generating recent enrollments fragment for Course##{@course.id} ---"
      recent_enrollments_json
    end
  end

  private

  attr_reader :course

  def latest_enrollment_timestamp
    course.enrollments.maximum(:updated_at)&.utc&.to_fs(:usec) || "none"
  end

  def recent_enrollments_cache_key
    "courses/#{course.id}/recent_enrollments/#{latest_enrollment_timestamp}"
  end
end
