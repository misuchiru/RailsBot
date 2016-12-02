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
            when "北安組位置"
              message = {
                "type": "location",
                "title": "劍南地區北安組",
                "address": "104台北市中山區大直街20巷11號1樓",
                "latitude": 25.081426,
                "longitude": 121.545654
              }
            when "基湖組位置"
              message = {
                "type": "location",
                "title": "劍南地區基湖組",
                "address": "104台北市中山區北安路841巷2號2樓",
                "latitude": 25.0847276,
                "longitude": 121.5572759
              }
            when "北安組位置"
              message = {
                "type": "location",
                "title": "劍南地區北安組",
                "address": "104台北市中山區大直街20巷11號1樓",
                "latitude": 25.081426,
                "longitude": 121.545654
              }
            when "培英組位置"
              message = {
                "type": "location",
                "title": "劍南地區培英組",
                "address": "104台北市中山區大直街62巷5弄10號2樓",
                "latitude": 25.083722,
                "longitude": 121.5427083
              }
            when "敬業組位置"
              message = {
                "type": "location",
                "title": "大直地區敬業組",
                "address": "104台北市中山區明水路397巷7弄10號1樓",
                "latitude": 25.0778148,
                "longitude": 121.5462907
              }
            when "永安組位置"
              message = {
                "type": "location",
                "title": "大直地區永安組",
                "address": "104台北市中山區明水路397巷7弄10號1樓",
                "latitude": 25.0778148,
                "longitude": 121.5462907
              }
            when "實踐組位置"
              message = {
                "type": "location",
                "title": "大直地區實踐組",
                "address": "104台北市中山區大直街2巷17號1樓",
                "latitude": 25.0809838,
                "longitude": 121.543315
              }
            when "德明組位置"
              message = {
                "type": "location",
                "title": "西湖地區德明組",
                "address": "114台北市內湖區環山路一段136巷14弄1號2樓",
                "latitude": 25.0876635,
                "longitude": 121.5661088
              }
            when "治磐組位置"
              message = {
                "type": "location",
                "title": "西湖地區治磐組",
                "address": "114台北市內湖區內湖路一段285巷69弄39號1樓",
                "latitude": 25.0846806,
                "longitude": 121.566711
              }
            when "文湖組位置"
              message = {
                "type": "location",
                "title": "西湖地區文湖組",
                "address": "114台北市內湖區內湖路一段47巷8弄1號1樓",
                "latitude": 25.0871439,
                "longitude": 121.5569343
              }
            when "瑞欣組位置"
              message = {
                "type": "location",
                "title": "文德地區瑞欣組",
                "address": "114台北市內湖區江南街71巷16弄2號1樓",
                "latitude": 25.0760845,
                "longitude": 121.5758807
              }
            when "瑞光組位置"
              message = {
                "type": "location",
                "title": "文德地區瑞光組",
                "address": "114台北市內湖區瑞光路245號4樓",
                "latitude": 25.0747437,
                "longitude": 121.5757338
              }
            when "瑞陽組位置"
              message = {
                "type": "location",
                "title": "文德地區瑞陽組",
                "address": "114台北市內湖區港墘路127巷13號1樓",
                "latitude": 25.0776132,
                "longitude": 121.5740218
              }
            when "港華組位置"
              message = {
                "type": "location",
                "title": "欣湖地區港華組",
                "address": "114台北市內湖區內湖路一段591巷11弄11號2樓",
                "latitude": 25.081107,
                "longitude": 121.5715086
              }
            when "港富組位置"
              message = {
                "type": "location",
                "title": "欣湖地區港富組",
                "address": "114台北市內湖區港墘路3號4樓",
                "latitude": 25.0836659,
                "longitude": 121.5762161
              }
            when "港都組位置"
              message = {
                "type": "location",
                "title": "欣湖地區港都組",
                "address": "114台北市內湖區內湖路二段29巷6號1樓",
                "latitude": 25.0790834,
                "longitude": 121.5773535
              }
            when "麗山組位置"
              message = {
                "type": "location",
                "title": "欣湖地區港都組",
                "address": "114台北市內湖區內湖路一段629巷45號B1樓",
                "latitude": 25.0815197,
                "longitude": 121.5730023
              }
            when "潭美組位置"
              message = {
                "type": "location",
                "title": "新明地區潭美組",
                "address": "114台北市內湖區潭美街215號B1樓",
                "latitude": 25.0558443,
                "longitude": 121.5826346
              }
            when "週美組位置"
              message = {
                "type": "location",
                "title": "新明地區週美組",
                "address": "114台北市內湖區新明路168號2樓",
                "latitude": 25.0575553,
                "longitude": 121.5834387
              }
            when "行善組位置"
              message = {
                "type": "location",
                "title": "新明地區行善組",
                "address": "114台北市內湖區新明路451巷14號1樓",
                "latitude": 25.0543943,
                "longitude": 121.5781856
              }
            end
            response = client.reply_message(event['replyToken'], message)
        end
      end
    end
    render status: 200, json: { message: 'OK' }
  end
end
