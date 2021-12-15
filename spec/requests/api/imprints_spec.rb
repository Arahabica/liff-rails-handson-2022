require 'rails_helper'


def sign_in
  create(:user1)
  headers = { "Content-Type" => "application/json" }
  params = {
    email: "test-user+1@example.com",
    password: "password"
  }
  post '/api/auth/sign_in', params: params.to_json, headers: headers
  response.headers
end
def get_auth_headers
  sign_in_headers = sign_in
  {
    "Content-Type" => "application/json",
    "access-token" => sign_in_headers['access-token'],
    "client" => sign_in_headers['client'],
    "expiry" => sign_in_headers['expiry'],
    "uid" => sign_in_headers['uid']
  }
end

describe "/api/imprints", type: :request do
  describe 'POST /' do
    it '未ログイン' do
      headers = { "Content-Type" => "application/json" }
      post '/api/imprints/', headers: headers
      expect(response.status).to eq(401)
    end
    it 'アクティベーションキーなし' do
      # stamp idは容易に推測できるので押印にはアクティベーションキーを必要とする
      headers = get_auth_headers
      stamp = Stamp.find(1)
      activation_key = stamp.activation_key
      params = {
        stamp_id: 1
      }
      post '/api/imprints/', params: params.to_json, headers: headers
      expect(response.status).to eq(400)
    end
    it 'アクティベーションキー不正' do
      headers = get_auth_headers
      stamp = Stamp.find(1)
      activation_key = stamp.activation_key
      params = {
        stamp_id: 1,
        activation_key: 'incorrect'
      }
      post '/api/imprints/', params: params.to_json, headers: headers
      expect(response.status).to eq(400)
    end
    it 'スタンプ押印' do
      headers = get_auth_headers
      stamp = Stamp.find(1)
      activation_key = stamp.activation_key
      params = {
        stamp_id: 1,
        activation_key: activation_key
      }
      post '/api/imprints/', params: params.to_json, headers: headers
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json['stamp_id']).to be 1
    end
    it '二重押印' do
      headers = get_auth_headers
      stamp = Stamp.find(2)
      activation_key = stamp.activation_key
      params = {
        stamp_id: 2,
        activation_key: activation_key
      }
      post '/api/imprints/', params: params.to_json, headers: headers
      post '/api/imprints/', params: params.to_json, headers: headers
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json['stamp_id']).to be 2
      user_id = json['user_id']
      imprints = Imprint.where(user_id: user_id, stamp_id: 2)
      expect(imprints.length).to be 1
    end
    it '押印後のステータス確認' do
      headers = get_auth_headers
      [1,2,3].each do |stamp_id|
        stamp = Stamp.find(stamp_id)
        activation_key = stamp.activation_key
        params = {
          stamp_id: stamp_id,
          activation_key: activation_key
        }
        post '/api/imprints/', params: params.to_json, headers: headers
      end

      get "/api/stamps", headers: headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.filter{|t| t['imprinted']}.length).to be 3
      expect(json.filter{|t| t['front_image'].present?}.length).to be 3
      expect(json.filter{|t| t['front_image'].blank?}.length).to be 4
    end
  end
end
