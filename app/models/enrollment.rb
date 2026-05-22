# frozen_string_literal: true

# Using touch: true will cause the associated User and Course records
# to update their updated_at timestamp whenever their Enrollment is saved.
# This technique helps to invalidate fragment caches that use versioned keys.
class Enrollment < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :course, touch: true
end
