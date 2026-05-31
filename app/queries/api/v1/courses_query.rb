# frozen_string_literal: true

module Api
  module V1
    class CoursesQuery
      def initialize(params, scope = Course.all)
        @params = params
        @scope = scope
      end

      def call(offset, limit)
        result = @scope
        result = filter_by_status(result)
        result = include_enrollments(result)
        result = apply_sorting(result)

        {
          total: result.count,
          courses: result.offset(offset).limit(limit)
        }
      end

      private

      attr_reader :params

      def filter_by_status(relation)
        case params[:status]
        when "published"
          case params[:recent]
          when "true"
            relation.recently_published
          else
            relation.published
          end
        when "draft"
          relation.drafts
        else
          relation
        end
      end

      def include_enrollments(relation)
        return relation unless params[:enrollments] == "true"

        relation.includes(:enrollments)
      end

      def apply_sorting(relation)
        if params[:sort] == "new"
          if params[:status] == "published"
            relation.order(published_at: :desc)
          else
            relation.order(created_at: :desc)
          end
        else
          if params[:status] == "published"
            relation.order(:published_at)
          else
            relation.order(:created_at)
          end
        end
      end
    end
  end
end
