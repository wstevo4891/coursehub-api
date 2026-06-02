class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :email, :is_admin, :created_at, :updated_at, :avatar_url

  def avatar_url
    if object.avatar.attached?
      # Option 1: url_for
      url_for(object.avatar)

      # Option 2: rails_blob_url (explicit alias for url_for)
      # rail_blob_url(object.avatar, only_path: false)

      # Option 3: service_url
      # direct link, often temporary for cloud
      # Make sure 'routes.default_url_options' are set for the host.
      # object.avatar.service_url
    else
      # Return nil or a default avatar URL if no avatar is attached
      # e.g., "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(object.email)}?d=identicon"
      nil
    end
  end
end
