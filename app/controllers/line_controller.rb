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
          # when Line::Bot::Event::MessageType::Text
          #   say_message = event.message['text']
          #   if say_message.include?("roy")
          #     message = {
          #       type: 'text',
          #       text: "roy是白癡"
          #     }
          #   else
          #     message = {
          #       type: 'text',
          #       text: "#{say_message}"
          #     }
          #   end
          #   response = client.reply_message(event['replyToken'], message)
          when Line::Bot::Event::MessageType::Location
            say_message = event.message['text']
            if say_message.include?("劍南北安組地點")
              message = {
                "type": "location",
                "title": "劍南地區北安組",
                "address": "104台北市中山區大直街20巷11號",
                "latitude": 25.081426,
                "longitude": 121.545654
              }
            end
            response = client.reply_message(event['replyToken'], message)
        end
      end
    end
    render status: 200, json: { message: 'OK' }
  end
end
