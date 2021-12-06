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
describe '/api/stamps', type: :request do
  describe 'GET /' do
    it '未ログイン' do
      headers = { "Content-Type" => "application/json" }
      get '/api/stamps/', headers: headers
      expect(response.status).to eq(401)
    end
    it 'スタンプ取得' do
      headers = get_auth_headers
      get '/api/stamps/', headers: headers
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(7)
    end
  end
  describe 'GET /:id' do
    it '未ログイン' do
      headers = { "Content-Type" => "application/json" }
      get '/api/stamps/1', headers: headers
      expect(response.status).to eq(401)
    end
    it 'アクティベーションキーなし' do
      # アクティベーションキーなしのリクエストではスタンプの画像を返さない
      headers = get_auth_headers
      get '/api/stamps/1', headers: headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['name']).to eq('弁財天')
      expect(json['front_image']).to be_falsy
    end
    it 'アクティベーションキーあり' do
      # アクティベーションキーありのリクエストではスタンプの画像を返す
      headers = get_auth_headers
      stamp = Stamp.find(1)
      act_key = stamp.activation_key
      get "/api/stamps/1?act_key=#{act_key}", headers: headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['name']).to eq('弁財天')
      expect(json['front_image']).to eq stamp.front_image
    end
  end
end