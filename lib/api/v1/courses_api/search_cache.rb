# frozen_string_literal: true

module Api
  module V1
    module CoursesApi
      class SearchCache
        MESSAGE = "--- Cache Miss! Fetching search data for courses ---"

        attr_reader :key

        def initialize(params, paginator)
          @params = params
          @per_page = paginator.per_page
          @page = paginator.page
          @key = generate_cache_key
        end

        def log_message
          puts MESSAGE
          Rails.logger.info MESSAGE
        end

        private

        attr_reader :params, :per_page, :page

        def generate_cache_key
          cache_key = "courses/"
          cache_key += status_segment
          cache_key += enrollments_segment
          cache_key += sort_segment

          "#{cache_key}/per_page=#{per_page}/page=#{page}"
        end

        def status_segment
          case params[:status]
          when "published"
            if params[:recent] == "true"
              "recently_published/"
            else
              "published/"
            end
          when "draft"
            "drafts/"
          else
            ""
          end
        end

        def enrollments_segment
          params[:enrollments] == "true" ? "with_enrollments/" : ""
        end

        def sort_segment
          params[:sort] == "new" ? "new/" : "old/"
        end
      end
    end
  end
end
