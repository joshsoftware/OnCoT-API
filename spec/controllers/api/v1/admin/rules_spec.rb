# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::RulesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:drive) do
    create(:drive, created_by_id: user.id, updated_by_id: user.id,
                   organization: organization)
  end
  let(:rule) { create(:rule, drive_id: drive.id) }

  describe 'POST #CREATE' do
    it 'Creates the rule' do
      post :create,
           params: { type_name: Faker::Lorem.word, description: Faker::Lorem.sentence,
                     drive_id: drive.id }

      rule = json

      expect(rule['data']['rule']['type_name']).to eq(request.params[:type_name])
      expect(response).to have_http_status(:ok)
    end

    it 'fails Create action as not passing drive id' do
      post :create,
           params: { type_name: Faker::Lorem.word, description: Faker::Lorem.sentence }

      rule = json

      expect(rule['drive'][0]).to eq('must exist')
      expect(response).to have_http_status(400)
    end
  end

  describe 'PUT #UPDATE' do
    it 'Updates the rule' do
      expect do
        put :update,
            params: { id: rule.id, type_name: 'changed rule type',
                      description: Faker::Lorem.sentence, drive_id: drive.id }
      end.to change { rule.reload.type_name }.from(rule.type_name).to('changed rule type')

      expect(response).to have_http_status(:ok)
    end

    it 'returns the not found error as passing random id which is not present in database' do
      patch :update, params: { id: Faker::Number.number(digits: 5) }
      expect(response.body).to eq('Record not found')
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET #SHOW' do
    it 'shows all rules related to a drive' do
      get :show, params: { id: drive.id }

      data = json
      rules = Rule.where(drive_id: request.params[:id])

      expect(data['data']['rules'].count).to eq(rules.count)
      expect(response).to have_http_status(:ok)
    end

    it 'returns the not found error as passing random id which is not present in database' do
      patch :update, params: { id: Faker::Number }
      expect(response.body).to eq('Record not found')
      expect(response).to have_http_status(404)
    end
  end
end
