require "http"

class StatusesController < ApplicationController
    def index
        response = HTTP.get('http://localhost:3000/statuses')
        res = JSON.parse response
        render json:{
            data: res
        }
    end
end
