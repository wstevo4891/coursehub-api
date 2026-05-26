# Additional behavior to add:
#
# 1. Communicate limits with response headers:
# - X-RateLimit-Limit
# - X-RateLimit-Remaining
# - X-RateLimit-Reset
#
# 2. If you issue API keys to clients, throttle based on the key to enforce usage quotas.
#
# 3. Throttle based on user ID to avoid penalizing mutliple users behind the same IP.
# - ideal for logged-in user actions
#
class Rack::Attack
  cache.store = ActiveSupport::Cache.lookup_store(*Rails.application.config.cache_store)

  # Throttle requests by IP Address
  # ================================
  # Allow 60 requests per minute for all IPs
  throttle("req/ip", limit: 60, period: 1.minute) do |req|
    # Specifies that the IP address should be used as the unique identifier
    # for counting requests.
    req.ip
  end

  # Throttle Login Attempts by Email Address
  # =========================================
  # Prevent brute-force login attacks by limiting login attempts per email address.
  # Allow 5 login attempts per 20 seconds for POST /api/vX/login requests.
  throttle("logins/email", limit: 5, period: 20.seconds) do |req|
    # Apply only to login path and POST method
    if req.path == "/api/v1/login" && req.post?
      # Use the email parameter (case-insensitive) as the identifier.
      # Normalize the email address to handle variations.
      req.params["email"].to_s.downcase.strip if req.params["email"].present?
    end
  end

  # Optional: Blocklist Specific IPs
  # =================================
  # Assuming a hypothetical Fail2Ban integration...
  # blocklist("fail2ban pentesters") do |req|
  #   Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 10, findtime: 1.day, bantime: 1.week) do
  #     CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
  #       req.path.include?("/etc/passwd") ||
  #       req.path.include?("wp-admin") ||
  #       req.path.include?("wp-login")
  #   end
  # end

  # Customize Throttled Response
  # =============================
  self.throttled_response = lambda do |request|
    retry_after = (request.env["rack.attack.match_data"] || {})[:period]

    headers = {
      "Content-Type" => "application/json",
      "Retry-After" => retry_after.to_s
    }

    body = {
      error: "Throttle limit reached. Retry later."
    }.to_json

    [ 429, headers, [ body ] ]
  end
end
