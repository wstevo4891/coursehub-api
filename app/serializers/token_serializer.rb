# frozen_string_literal: true

class TokenSerializer
  def call(user, tokenizer = JsonWebToken)
    new(user, tokenizer).as_json
  end

  def initialize(user, tokenizer = JsonWebToken)
    @refresh_token = user.refresh_tokens.create!
    @access_token_expiration = 15.minutes.from_now
    @access_token = generate_access_token(user.id, tokenizer)
  end

  def as_json
    {
      access_token: access_token,
      exp: access_token_expiration.to_i,
      refresh_token: refresh_token.token
    }
  end

  private

  attr_reader :refresh_token, :access_token_expiration, :access_token

  def generate_access_token(user_id, tokenizer)
    tokenizer.encode({ user_id: user_id }, access_token_expiration)
  end
end
