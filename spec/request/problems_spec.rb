require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  before do
    @organization = FactoryBot.create(:organization)
    @user = FactoryBot.create(:user)
  end

  it 'returns the problem statement and description' do
    @problem = FactoryBot.create(:problem, updated_by_id: @user.id, created_by_id: @user.id,
                                           organization: @organization)
    get :show, params: { id: @problem.id }
    expect(JSON.parse(response.body).size).to eq(2)
  end
end
