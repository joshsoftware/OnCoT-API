# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RulesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:drive) do
    create(:drive, created_by_id: user.id, updated_by_id: user.id,
                   organization: organization)
  end
  let!(:rule) { create(:rule, drive_id: drive.id) }

  describe 'GET #INDEX' do
    context 'with valid params' do
      it 'returns all rules related to a drive' do
        get :index, params: { drive_id: drive.id }

        data = json

        expect(data['data']['rules'].count).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'returns the not found error as passing random id which is not present in database' do
        get :index, params: { drive_id: Faker::Number.number }

        expect(response.body).to eq(I18n.t('not_found.message'))
        expect(response).to have_http_status(404)
      end
    end
  end
end
