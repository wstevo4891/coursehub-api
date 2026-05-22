class Course < ApplicationRecord
  # === Attributes =========================================
  enum :status, %w[draft published]

  # === Associations =======================================
  has_many :enrollments
  has_many :users, through: :enrollments

  # === Scopes =============================================
  scope :drafts, -> { where(status: "draft") }

  scope :published, -> { where(status: "published") }

  # === Instance Methods ===================================
  def publish!
    self.status = "published"
    self.published_at = Time.now
    save
  end
end
