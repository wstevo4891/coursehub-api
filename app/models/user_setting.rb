class UserSetting
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields =============================================
  field :user_id, type: Integer

  field :theme, type: String, default: "light"

  field :language, type: String, default: "en"

  field :notifications, type: Hash, default: {}

  # === Instance Methods ===================================
  def user
    User.find(self.user_id)
  end
end
