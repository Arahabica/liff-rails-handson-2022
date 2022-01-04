require 'net/http'
require 'uri'

module LineTokenAuth::Concerns::LineAuthenticator
  extend ActiveSupport::Concern

  protected

  def authenticate(uid, access_token)
    verify_result = verify_line_token(access_token)
    if verify_result[:code] != 200
      return fail_authenticate(verify_result[:code], verify_result[:body]["error_description"])
    end
    if verify_result[:body]["client_id"] != line_channel_id
      return fail_authenticate(401, 'LINE Channel ID is not matched.')
    end
    if verify_result[:body]["expires_in"] <= 0
      return fail_authenticate(401, 'LINE access token is expired')
    end
    profile_result = get_profile_by_line_token(access_token)
    if profile_result[:code] != 200
      return fail_authenticate(profile_result[:code], profile_result[:body][:error_description])
    end
    if profile_result[:body]["userId"] != uid
      return fail_authenticate(401, 'uid is not matched.')
    end
    success_authenticate({
      uid: uid,
      name: profile_result[:body]["displayName"],
      image: profile_result[:body]["pictureUrl"]
    })
  end
  private
  def line_channel_id
    @line_channel_id ||=  ENV["LINE_CHANNEL_ID"]
  end
  def verify_line_token(access_token)
    uri = URI.parse("https://api.line.me/oauth2/v2.1/verify")
    uri.query = URI.encode_www_form(access_token: access_token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new uri.request_uri
    res = http.request req
    {
      code: res.code.to_i,
      body: JSON.parse(res.body)
    }
  end
  def get_profile_by_line_token(access_token)
    uri = URI.parse("https://api.line.me/v2/profile")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new uri.request_uri
    req[:Authorization] = "Bearer #{access_token}"
    res = http.request req
    {
      code: res.code.to_i,
      body: JSON.parse(res.body)
    }
  end
  def fail_authenticate(code, message)
    { error: { code: code, message: message }, profile: nil }
  end
  def success_authenticate(profile)
    { error: nil, profile: profile }
  end
end