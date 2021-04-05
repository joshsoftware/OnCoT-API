# frozen_string_literal: true

require 'http'

module Api
  module V1
    class StatusesController < ApplicationController
      def index
        response = JudgeZeroApi.new.get('/statuses')
        render json: response
      end
    end
  end
end
