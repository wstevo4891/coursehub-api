# :script_src is required, falling back to default-src is too dangerous.
# Use `script_src: OPT_OUT` to override (SecureHeaders::ContentSecurityPolicyConfigError)

SecureHeaders::Configuration.default do |config|
  # === Strict-Transport-Security (HSTS) ===
  # Enforce HTTPS for the site and subdomains after the first visit.
  # "max-age" is in seconds (e.g. 1. year).
  # "preload" allows submission to browser HSTS preload lists.
  # Crucial for production HTTPS.
  config.hsts = "max-age=#{1.year.to_i}; includeSubdomains; preload"

  # === X-Frame-Options ===
  # Prevents clickjacking by controlling if the site can be embedded in frames.
  # DENY: No framing allowed (most secure)
  # SAMEORIGIN: Allow framing only by pages from the same origin.
  config.x_frame_options = "DENY"

  # === X-Content-Type-Options ===
  # Prevents browsers from MIME-sniffing response content types.
  # Forces the browser to rely on the "Content-Type" header.
  config.x_content_type_options = "nosniff"

  # === X-XSS-Protection ===
  # Enables browser's built-in XSS filter.
  # Note: Modern browsers largely rely on Content-Security-Policy instead.
  # "1;mode=block" tells the browser to block the page if XSS is detected.
  config.x_xss_protection = "1; mode=block"

  # === Content-Security-Policy (CSP) ===
  # The most powerful header for preventing XSS and data injection.
  # Defines approved sources for content (scripts, styles, images, etc.).
  # Requires careful configuration based on your app's needs.
  # A very restrictive policy suitable for many JSON APIs:
  config.csp = {
    # Deny everything by default
    default_src: %w['none'],
    script_src: %w['none'],

    # Disallow embedding in frames (overlaps X-Frame-Options)
    frame_ancestors: %w['none'],

    # Allow forms to submit to the same origin
    form_action: %w['self']

    # Block HTTP assets on HTTPS pages
    # block_all_mixed_content: true,

    # Ask browser to upgrade HTTP requests to HTTPS
    # upgrade_insecure_requests: true
  }

  # === Referrer-Policy ===
  # Controls how much referrer information is sent with requests.
  # 'strict-origin-when-cross-origin': Sends origin (no path) for cross-origin,
  # full URL for same-origin. Good balance of privacy and utility.
  config.referrer_policy = %w[strict-origin-when-cross-origin]

  # === Permissions-Policy ===
  # Controls which browser features (camera, microphone, geolocation, etc.)
  # the site can use. Important for user privacy and security.
  # Example: Disable microphone and geolocation access
  # config.permissions_policy = {
  #   microphone: %w[none],
  #   geolocation: %w[none]
  # }
end
