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
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      context 'with valid params' do
        it 'Creates the rule' do
          post :create,
               params: { type_name: Faker::Lorem.word, description: Faker::Lorem.sentence,
                         drive_id: drive.id }

          rule = json

          expect(rule['data']['rule']['type_name']).to eq(request.params[:type_name])
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid params' do
        it 'fails to create as not passing drive id' do
          post :create,
               params: { type_name: Faker::Lorem.word, description: Faker::Lorem.sentence }

          rule = json

          expect(rule['drive'][0]).to eq('must exist')
          expect(response).to have_http_status(400)
        end
      end
    end
    context 'When user is not logged in' do
      it 'asks to login' do
        post :create,
             params: { type_name: Faker::Lorem.word, description: Faker::Lorem.sentence,
                       drive_id: drive.id }

        rule = json

        expect(rule['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT #UPDATE' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      context 'with valid params' do
        it 'Updates the rule' do
          expect do
            put :update,
                params: { id: rule.id, type_name: 'changed rule type',
                          description: Faker::Lorem.sentence, drive_id: drive.id }
          end.to change { rule.reload.type_name }.from(rule.type_name).to('changed rule type')

          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          patch :update, params: { id: Faker::Number.number(digits: 5) }
          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        put :update,
            params: { id: rule.id, type_name: 'changed rule type',
                      description: Faker::Lorem.sentence, drive_id: drive.id }
        rule = json

        expect(rule['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #INDEX' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      context 'with valid params' do
        it 'returns all rules related to a drive' do
          get :index, params: { drive_id: drive.id }

          data = json
          rules = Rule.where(drive_id: request.params[:drive_id])

          expect(data['data']['rules'].count).to eq(rules.count)
          expect(response).to have_http_status(:ok)
        end
      end
      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          get :index, params: { id: Faker::Number.number }

          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is logged in' do
      it ' ask for login ' do
        get :index, params: { id: drive.id }

        rule = json

        expect(rule['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end
  describe 'DELETE #DESTROY' do
    context 'When user is logged in' do
      before do
        auth_tokens_for_user(user)
      end

      context 'with valid params' do
        it 'deletes a rule' do
          delete :destroy, params: { id: rule.id }

          data = json
          expect(Rule.count).to eq(0)
          expect(data['message']).to eq(I18n.t('destroy.success', model_name: Rule))
          expect(response).to have_http_status(:ok)
        end
      end
      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          get :index, params: { id: Faker::Number.number }

          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is logged in' do
      it ' ask for login ' do
        get :index, params: { drive_id: drive.id }

        rule = json

        expect(rule['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end
end
