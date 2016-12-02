require 'line/bot'
class LineController < ApplicationController
  protect_from_forgery with: :null_session
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
          when Line::Bot::Event::MessageType::Text
            say_message = event.message['text']
            case say_message
            when "劍南北安組位置"
              message = {
                "type": "location",
                "title": "劍南地區北安組",
                "address": "104台北市中山區大直街20巷11號1樓",
                "latitude": 25.081426,
                "longitude": 121.545654
              }
            when "劍南基湖組位置"
              message = {
                "type": "location",
                "title": "劍南地區基湖組",
                "address": "104台北市中山區北安路841巷2號2樓",
                "latitude": 25.0847276,
                "longitude": 121.5572759
              }
            end
            response = client.reply_message(event['replyToken'], message)
        end
      end
    end
    render status: 200, json: { message: 'OK' }
  end
end
