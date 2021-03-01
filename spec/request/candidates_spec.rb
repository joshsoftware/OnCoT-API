require 'rails_helper'

describe '/candidates#update' do

    let!(:candidate) { create(:candidate) }
    let(:candidates_params) do
      {
         first_name: ca
        
      }
    end

  
    it 'is successful' do
      put '/candidate/2', params: user_params
      expect(response).to have_http_status 200

    end
  end
