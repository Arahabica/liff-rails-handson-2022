require 'line/bot'

class ImprintsController < ApplicationController

  def create
    activation_key = params[:activation_key]
    stamp_id = params[:stamp_id]
    user_id = 1
    stamp = Stamp.find(stamp_id)
    if stamp.activation_key != activation_key
      return render json: { error: 'Activation key is invalid.' }, status: :bad_request
    end
    @imprint = Imprint.find_by(user_id: user_id, stamp_id: stamp_id)
    if @imprint.blank?
      # 二重押印はエラーにせず、処理をスキップ
      @imprint = Imprint.create!(user_id: user_id, stamp_id: stamp_id)
      count = Imprint.where(user_id: user_id).count
      if count >= 7
        puts "send coupon"
      end
    end
  end
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def send_coupon(uid)
    message1 = {
      type: "text",
      text: "七福神コンプリートおめでとうございます🎉"
    }
    message2 = {
      type: "flex",
      altText: "クッキー引換券",
      contents: {
        type: "bubble",
        hero: {
          type: "image",
          url: "https://rsasage.s3.ap-northeast-1.amazonaws.com/connpass/event20220119/cookie.png",
          size: "full",
          aspectRatio: "10:10",
          aspectMode: "cover"
        },
        body: {
          type: "box",
          layout: "vertical",
          contents: [
            {
              type: "text",
              text: "クッキー引換券",
              weight: "bold",
              size: "xl"
            },
            {
              type: "text",
              text: "こちらの引換券を▢△◯堂のレジで見せてください",
              wrap: true
            }
          ]
        }
      }
    }
    response = client.push_message(uid, [message1, message2])
    response.code.to_i == 200
  end
end
