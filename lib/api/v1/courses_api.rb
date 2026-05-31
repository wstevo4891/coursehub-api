# frozen_string_literal: true

module Api
  module V1
    module CoursesApi
      def self.search_courses(params)
        paginator = Paginator.new(params[:pagination])
        cache = SearchCache.new(params[:query], paginator)

        Rails.cache.fetch(cache.key, expires_in: 1.hour) do
          cache.log_message

          query = CoursesQuery.new(params[:query])
          results = query.call(paginator.page_offset, paginator.per_page)
          serializer = SearchSerializer.new(paginator, results)

          if params[:query][:enrollments]
            serializer.as_json_with_enrollments
          else
            serializer.as_json
          end
        end
      end
    end
  end
end
