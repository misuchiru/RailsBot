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
            if say_message.include?("劍南北安組")
              message = {
                "type": "location",
                "title": "my location",
                "address": "〒150-0002 東京都渋谷区渋谷２丁目２１−１",
                "latitude": 35.65910807942215,
                "longitude": 139.70372892916203
              }
            end
            response = client.reply_message(event['replyToken'], message)
        end
      end
    end
    render status: 200, json: { message: 'OK' }
  end
end
