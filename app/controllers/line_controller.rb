class LineController < ApplicationController
  MESSAGE_TYPE_TO_METHOD_MAP = {
    "text" => :echo_text,
    "location" => :echo_location,
  }.freeze
  protect_from_forgery with: :null_session
  def echo
    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    body = request.body.read
    unless client.validate_signature(body, signature)
      head :bad_request
      return
    end
    events = client.parse_events_from(body)
    events.each do |event|
      message_target = find_or_create_message_target(event) ## message_group or message_user or message_roomが入る。透過的に扱えるように設計しておく。
      case event
      when Line::Bot::Event::Message
        message = Message.new(message_target_id: message_target.id, message_target_type: event["source"]["type"], message_type: event.type.to_sym, chat_id: message_target.chat_id)
        send(MESSAGE_TYPE_TO_METHOD_MAP[event.type.to_s], message, event)
      when Line::Bot::Event::Follow
        receive_follow(message_target)
      when Line::Bot::Event::Unfollow
        receive_unfollow(message_target)
      when Line::Bot::Event::Join
        receive_join(message_target)
      when Line::Bot::Event::Leave
        receive_leave(message_target)
      end
    end
    head :ok
  end
  def echo_text(message, event)
    MessageText.create!(message: message, value: event.message["text"])
    client.reply_message(event['replyToken'], {
      type: "text",
      text: message.message_text_value
    })
  end
  def echo_location(message, event)
    message_param = event.message
    title = message_param["title"]
    address = message_param["address"]
    latitude = message_param["latitude"]
    longitude = message_param["longitude"]
    MessageLocation.create!(message: message, title: title, address: address, latitude: latitude, longitude: longitude)
    client.reply_message(event['replyToken'], {
      type: "location",
      title: message.message_location_title,
      address: message.message_location_address,
      latitude: message.message_location_lat,
      longitude: message.message_location_long,
    })
  end
  def receive_follow(message_target)
    client.push_message(
      message_target.platform_id, # userIdが入る
      {
        type: "text",
        text: "友達登録ありがとうございます！"
      }
    )
  end
  def receive_unfollow(message_target)
     message_target.blocked = true
     message_target.save!
  end

  def receive_join(message_target)
   client.push_message(
     message_target.platform_id, # groupID or roomIdが入る
     {
       type: "text",
       text: "招待ありがとうございます！"
     }
   )
  end
  def receive_leave(message_target)
    message_target.leaved = true
    message_target.save!
  end
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  end
end
