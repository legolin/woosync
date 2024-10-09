class ImportChannel < ApplicationCable::Channel
  def subscribed
    stream_from "update_products"
  end

  def receive(data)
    puts data["message"]
    ActionCable.server.broadcast("test", "ActionCable is connected")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
