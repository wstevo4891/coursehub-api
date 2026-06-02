class Course < ApplicationRecord
  # === Attributes =========================================
  enum :status, %w[draft published]

  has_one_attached :video

  has_many_attached :documents

  # === Associations =======================================
  has_many :enrollments
  has_many :users, through: :enrollments

  # === Scopes =============================================
  scope :drafts, -> { where(status: "draft") }

  scope :published, -> { where(status: "published") }

  scope :recently_published, -> { published.where("published_at <= ?", Time.current) }

  # === Class Methods ======================================
  def self.recently_published_with_enrollments
    recently_published
      .includes(:enrollments)
      .order(published_at: :desc)
      .limit(5)
  end

  def self.recently_published_enrollment_data
    cache_key = "courses/recently_published_with_enrollments"

    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      puts "--- Cache Miss! Running expensive query ---"

      recently_published_with_enrollments.map do |course|
        {
          id: course.id,
          title: course.title,
          published_at: course.published_at,
          enrollment_count: course.enrollments.size
        }
      end
    end
  end

  # === Instance Methods ===================================
  def publish!
    self.status = "published"
    self.published_at = Time.now
    save
  end

  def unpublish!
    self.status = "draft"
    self.published_at = nil
    save
  end
end
