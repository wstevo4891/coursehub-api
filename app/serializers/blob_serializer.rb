# frozen_string_literal: true

class BlobSerializer
  def self.call(params, user_id)
    new(params, user_id).as_json
  end

  def initialize(params, user_id)
    @blob = build_active_storage_blob(params, user_id)
  end

  def as_json
    {
      id: blob.id,
      key: blob.key,
      filename: blob.filename.to_s,
      content_type: blob.content_type,
      metadata: blob.metadata,
      service_name: blob.service_name,
      byte_size: blob.byte_size,
      checksum: blob.checksum,
      created_at: blob.created_at.iso8601,
      signed_id: blob.signed_id(purpose: :blob_id),
      direct_upload: {
        url: blob.service_url_for_direct_upload,
        headers: blob.service_headers_for_direct_upload
      }
    }
  end

  private

  attr_reader :blob

  # Use ActiveStorage::Blob#create_before_direct_upload!
  # This requires file metadata: filename, bute_size, checksum, content_type
  def build_active_storage_blob(params, user_id)
    ActiveStorage::Blob.create_before_direct_upload!(
      **params,
      metadata: {
        user_id: user_id
      }
    )
  end
end
