require 'rails_helper'
RSpec.describe 'Problem', type: :request do
    describe 'get problems/:id' do
      subject { get '/problem/2' }
  
      it 'returns success' do
        subject
        
        expect(response).to have_http_status(200)
      end
    end
  end