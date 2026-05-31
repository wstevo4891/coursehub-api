# frozen_string_literal: true

module Api
  module V1
    module CoursesApi
      class SearchSerializer
        def initialize(paginator, data, serializer = CourseSerializer)
          @paginator = paginator
          @total = data[:total]
          @courses = data[:courses]
          @serializer = serializer
        end

        def as_json
          {
            courses: courses_json,
            pagination: pagination_json
          }
        end

        def as_json_with_enrollments
          {
            courses: courses_with_enrollments_json,
            pagination: pagination_json
          }
        end

        private

        attr_reader :paginator, :total, :courses, :serializer

        delegate :page, :per_page, :total_pages, to: :paginator

        def generate_cache_key(key)
          "#{key}#{course_ids.join("-")}"
        end

        def courses_json
          courses.map { |task| serializer.call(task) }
        end

        def courses_with_enrollments_json
          courses.map do |course|
            course_serializer = serializer.new(course)

            {
              **course_serializer.as_json,
              recent_enrollments: course_serializer.recent_enrollments_json_cached
            }
          end
        end

        def pagination_json
          {
            current_page: page,
            per_page: per_page,
            total_pages: total_pages(total),
            total_count: total
          }
        end
      end
    end
  end
end
