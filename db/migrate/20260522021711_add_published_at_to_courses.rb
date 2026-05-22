class AddPublishedAtToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :published_at, :datetime
  end
end
