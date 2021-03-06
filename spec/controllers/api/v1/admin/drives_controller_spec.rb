# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe Api::V1::Admin::DrivesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user, role_id: role.id) }

  let(:problem) { create(:problem, created_by_id: user.id, updated_by_id: user.id) }
  let(:drive) { create(:drive, created_by_id: user.id, updated_by_id: user.id, organization: organization) }
  let(:drives_problem) { create(:drives_problem, drive_id: drive.id, problem_id: problem.id) }

  let(:candidate) { create(:candidate) }
  let!(:drives_candidate) do
    create(:drives_candidate, drive_id: drive.id, candidate_id: candidate.id, drive_start_time: DateTime.current,
                              drive_end_time: DateTime.current + 1.hours)
  end

  describe 'GET#index' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      it 'returns all drives' do
        get :index, params: { drive_id: drive.id }

        data = json
        expect(data['data']['drives'].count).to eq(Drive.count)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :index, params: { drive_id: drive.id }

        data = json

        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'action#create' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      context 'with valid params' do
        it 'creates a drive' do
          expect do
            post :create, params: { name: Faker::Name.name, organization_id: organization.id, created_by_id: user.id,
                                    updated_by_id: user.id, drives_problems_attributes: [{ "problem_id": problem.id,
                                                                                           "_destroy": false }] }
          end.to change { Drive.count }.to(2).from(1)

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'When user is not logged in' do
      it ' ask for login ' do
        post :create, params: { problem_id: problem.id, name: Faker::Name.name, organization_id: organization.id,
                                created_by_id: user.id, updated_by_id: user.id }
        data = json

        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'action#update' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      context 'with valid params' do
        it 'updates the particular drive details' do
          params = { problem_id: problem.id, id: drive.id, name: Faker::Name.name, drives_problem: drives_problem,
                     organization_id: organization.id, created_by_id: user.id, updated_by_id: user.id,
                     drives_problems_attributes: [{ "id": drives_problem.id, "problem_id": problem.id, "_destroy": false }] }

          expect do
            put :update, params: params
          end.to change { drive.reload.name }.from(drive.name).to(params[:name])

          expect(response).to have_http_status(:success)
        end
      end
      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          put :update, params: { id: Faker::Number, problem_id: problem.id }

          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        patch :update, params: { problem_id: problem.id, id: Faker::Number, name: Faker::Name.name,
                                 organization_id: organization.id, created_by_id: user.id, updated_by_id: user.id }
        data = json

        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET#show' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      context 'with valid params' do
        it 'shows details of particular drive' do
          get :show, params: { id: drive.id }

          data = json
          expect(data['data']['drive']['name']).to eq(drive.name)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid params' do
        it 'returns the not found error as passing random id which is not present in database' do
          get :show, params: { id: Faker::Number }

          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :show, params: { id: drive.id }

        data = json
        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET#candidate_list' do
    context 'when user is logged in' do
      before do
        auth_tokens_for_user(user)
      end
      context 'with valid params' do
        it 'shows details of all candidates of the respective drive' do
          get :candidate_list, params: { id: drive.id }

          data = json
          expect(data['data']['candidates'][0]['first_name']).to eq(candidate.first_name)
          expect(data['data']['candidates'][0]['email']).to eq(candidate.email)
          expect(data['data']['candidates'].count).to eq(1)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid params' do
        it 'returns the not found error on passing random drive id which is not present in database' do
          get :candidate_list, params: { id: Faker::Number }

          expect(response.body).to eq(I18n.t('not_found.message'))
          expect(response).to have_http_status(404)
        end
      end
    end
    context 'When user is not logged in' do
      it ' ask for login ' do
        get :candidate_list, params: { id: drive.id }

        data = json
        expect(data['errors'].first).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST # send_admin_email' do
    before do
      organization = create(:organization)
      user = create(:user)

      candidate = create(:candidate, first_name: 'Neha', last_name: 'Sharma', email: 'neha@gmail.com')
      @drive = create(:drive, updated_by_id: user.id, created_by_id: user.id,
                              organization: organization)
      drives_candidate = create(:drives_candidate, drive_id: @drive.id, candidate_id: candidate.id, score: 20, drive_start_time: DateTime.current,
                                                   drive_end_time: DateTime.current + 1.hours)
      problem = create(:problem, updated_by_id: user.id, created_by_id: user.id,
                                 organization: organization, submission_count: 3)
      create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id,
                          answer: 'puts "first submission"', total_marks: 10)
      create(:submission, problem_id: problem.id, drives_candidate_id: drives_candidate.id,
                          answer: 'puts "second submission"', total_marks: 20)
      auth_tokens_for_user(user)
    end
    it 'returns shortlisted candidates list in csv file' do
      params = {
        drife_id: @drive.id,
        score: 10
      }

      post :send_admin_email, params: params
      filename = "driveID_ #{@drive.id}_score_#{params[:score]}.csv"
      actual_row = [['First Name', 'Neha'], ['Last Name', 'Sharma'], ['Email', 'neha@gmail.com'],
                    ['code', 'puts "second submission"']]
      table = CSV.parse(File.read(filename), headers: true)
      expected_row = table.by_row[0]
      expect(expected_row).to match_array(actual_row)
      File.delete(filename)
    end
  end
end
