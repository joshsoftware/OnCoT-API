# frozen_string_literal: true

class TestChannel < ApplicationCable::Channel
  def subscribed
    stream_from params[:room]
  end
end
