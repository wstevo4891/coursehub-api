class WelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    # In a real app, we would use an ActionMailer class
    # UserMailer.welcome_email(user).deliver_now

    puts "======================================"
    puts "TO: #{user.email}"
    puts "FROM: no-reply@coursehub.com"
    puts "SUBJECT: Welcome to CourseHub!"
    puts ""
    puts "Hi #{user.name},"
    puts "Thanks for signing up!"
    puts "======================================"
  end
end
