# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."

User.find_or_create_by(email: "admin@example.com") do |user|
  user.name = "Admin User",
  user.password = "SecurePassword123",
  user.is_admin = true
end

puts "Created Admin User."

puts "Creating 30 sample users..."

(2..31).each do |num|
  User.find_or_create_by(id: num) do |user|
    user.email = Faker::Internet.email
    user.name = Faker::Name.name
    user.password = "password"
    user.is_admin = false
  end
end

puts "Sample users are in place."

puts "Clearing enrollments..."

Enrollment.delete_all

puts "Clearing courses..."

Course.delete_all

puts "Seeding courses and enrollments..."

course = Course.create(
  title: "Rails API",
  description: "Learn how to build a RESTful API in Ruby on Rails.",
  status: "published",
  published_at: 5.days.ago
)

User.offset(1).pluck(:id).sample(5).each do |user_id|
  course.enrollments.create(user_id: user_id)
end

course = Course.create(
  title: "Rails with MongoDB",
  description: "Learn how to build a NoSQL database in Rails with MongoDB.",
  status: "published",
  published_at: 4.days.ago
)

User.offset(1).pluck(:id).sample(5).each do |user_id|
  course.enrollments.create(user_id: user_id)
end

course = Course.create(
  title: "Rails with GraphQL",
  description: "Learn how to build a GraphQL API in Rails.",
  status: "published",
  published_at: 3.days.ago
)

User.offset(1).pluck(:id).sample(5).each do |user_id|
  course.enrollments.create(user_id: user_id)
end

Course.create(
  title: "Rails with Redis",
  description: "Learn how to cache pages and requests in Rails using Redis.",
  status: "draft"
)

Course.create(
  title: "Rails with PostgreSQL",
  description: "Learn how to build an application for data analysis with Rails and PostgreSQL.",
  status: "draft"
)

Course.create(
  title: "Rails with MySQL",
  description: "Learn how to build a performant read-heavy application with Rails and MySQL.",
  status: "draft"
)

puts "Courses and enrollments are in place."

puts "Finished seeding."
