# frozen_string_literal: true

module Api
  module V1
    module CoursesApi
      module Search
        def self.search_courses(params)
          paginator = Paginator.new(params[:pagination])
          cache = Cache.new(params[:query], paginator)

          cache.fetch do
            query = Query.new(params[:query])
            results = query.call(paginator.page_offset, paginator.per_page)
            serializer = Serializer.new(paginator, results)

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
end
