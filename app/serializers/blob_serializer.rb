# frozen_string_literal: true

class BlobSerializer
  def self.call(blob)
    new(blob).as_json
  end

  def initialize(blob)
    @blob = blob
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
end
