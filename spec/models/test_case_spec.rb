require 'rails_helper'

describe TestCase do
  it 'Must have a problem statement' do
    no_problem_testcase = TestCase.new(problem: nil)
    no_problem_testcase.should_not be_valid
  end

  it 'Should have one testcase result' do
    expect(TestCase.reflect_on_association(:test_case_result).macro).to eq :has_one
  end

  it 'created_by field cannot be empty' do
    no_user_testcase = TestCase.new(created_by: nil)
    no_user_testcase.should_not be_valid
  end

  it 'updated_by field cannot be empty' do
    no_user_testcase = TestCase.new(updated_by: nil)
    no_user_testcase.should_not be_valid
  end
end
