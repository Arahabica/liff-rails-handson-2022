require 'rails_helper'

describe '/api/auth', type: :request do
  describe '/sign_in' do
    it '空のリクエスト' do
      post '/api/auth/sign_in'
      json = JSON.parse(response.body)

      expect(response.status).to eq(401)
    end
    it 'サインイン成功' do
      create(:user1)
      headers = { "Content-Type" => "application/json" }
      params = {
       email: "test-user+1@example.com",
       password: "password"
      }
      post '/api/auth/sign_in', params: params.to_json, headers: headers
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(response.headers['access-token']).to be_truthy
      expect(response.headers['expiry']).to be_truthy
      expect(response.headers['client']).to be_truthy
      expect(response.headers['uid']).to eq 'test-user+1@example.com'
    end
    it 'サインイン失敗' do
      create(:user1)
      headers = { "Content-Type" => "application/json" }
      params = {
       email: "test-user+1@example.com",
       password: "incorrect"
      }
      post '/api/auth/sign_in', params: params.to_json, headers: headers
      json = JSON.parse(response.body)

      expect(response.status).to eq(401)
    end
  end

  describe '/validate_token' do
    it '空のリクエスト' do
      get '/api/auth/validate_token'
      json = JSON.parse(response.body)

      expect(response.status).to eq(401)
    end
    it '検証成功' do
      create(:user1)
      headers = { "Content-Type" => "application/json" }
      params = {
       email: "test-user+1@example.com",
       password: "password"
      }
      post '/api/auth/sign_in', params: params.to_json, headers: headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)

      headers = {
       "Content-Type" => "application/json",
       "access-token" => response.headers['access-token'],
       "client" => response.headers['client'],
       "expiry" => response.headers['expiry'],
       "uid" => response.headers['uid']
      }
      get '/api/auth/validate_token', headers: headers
      expect(response.status).to eq(200)
    end
    it '検証失敗' do
      create(:user1)
      headers = { "Content-Type" => "application/json" }
      params = {
       email: "test-user+1@example.com",
       password: "password"
      }
      post '/api/auth/sign_in', params: params.to_json, headers: headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)

      headers = {
       "Content-Type" => "application/json",
       "access-token" => 'invalid token',
       "client" => response.headers['client'],
       "expiry" => response.headers['expiry'],
       "uid" => response.headers['uid']
      }
      get '/api/auth/validate_token', headers: headers
      expect(response.status).to eq(401)
    end
  end
  describe '/sign_out' do
    it '空のリクエスト' do
      delete '/api/auth/sign_out'
      json = JSON.parse(response.body)

      expect(response.status).to eq(404)
    end
    it 'サインアウト成功' do
      create(:user1)
      headers = { "Content-Type" => "application/json" }
      params = {
       email: "test-user+1@example.com",
       password: "password"
      }
      post '/api/auth/sign_in', params: params.to_json, headers: headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)

      params = {
       uid: response.headers['uid'],
       "access-token": response.headers['access-token'],
       client: response.headers['client']
      }
      delete '/api/auth/sign_out', params: params.to_json, headers: headers
      expect(response.status).to eq(200)
    end
    it 'サインアウト失敗' do
      create(:user1)
      headers = { "Content-Type" => "application/json" }
      params = {
       email: "test-user+1@example.com",
       password: "password"
      }
      post '/api/auth/sign_in', params: params.to_json, headers: headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)

      params = {
       uid: response.headers['uid'],
       "access-token": 'abc',
       client: response.headers['client']
      }
      delete '/api/auth/sign_out', params: params.to_json, headers: headers
      expect(response.status).to eq(404)
    end
  end
end