class Message < ApplicationRecord
  delegate :value, to: :message_text, prefix: true, allow_nil: true
  delegate :title, :address, :lat, :long, to: :message_location, prefix: true, allow_nil: true


  belongs_to :chat
  has_one :message_text, dependent: :destroy
  has_one :message_location, dependent: :destroy

  enum message_type: [:text, :location]

end
