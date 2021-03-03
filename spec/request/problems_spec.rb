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

    @expected = {
      data: @problem,
      message: 'Succeessfully return statement'
    }.to_json
    response.body.should == @expected
    expect(response).to have_http_status(200)
  end
end
