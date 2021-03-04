require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  before do
    @organization = create(:organization)
    @user = create(:user)
  end

  it 'returns the problem data' do
    @problem = create(:problem, updated_by_id: @user.id, created_by_id: @user.id,
                                organization: @organization)
    get :show, params: { id: @problem.id }

    response.body.should == {
      data: @problem,
      message: 'Success'
    }.to_json
    expect(response).to have_http_status(200)
  end

  it 'returns the error as passing random id which is not present in database' do
    get :show, params: { id: Faker::Number }

    expect(response).to have_http_status(400)
  end
end
