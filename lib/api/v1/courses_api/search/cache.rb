# frozen_string_literal: true

module Api
  module V1
    module CoursesApi
      module Search
        class Cache
          attr_reader :key

          def initialize(params, paginator)
            @params = params
            @per_page = paginator.per_page
            @page = paginator.page
            @key = generate_cache_key
          end

          def fetch(&block)
            Rails.cache.fetch(key, expires_in: 1.hour) do
              Rails.logger.info "--- Cache Miss! Searching courses ---"
              block.call
            end
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
end
