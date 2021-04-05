# frozen_string_literal: true

module Api
  module V1
    class LanguagesController < ApplicationController
      def index
        response = JudgeZeroApi.new.get('/languages')
        render json: response
      end

      def all
        response = JudgeZeroApi.new.get('/languages/all')
        render json: response
      end

      def show
        response = JudgeZeroApi.new(params[:id]).get('/languages')
        render json: response.to_s
      end
    end
  end
end
