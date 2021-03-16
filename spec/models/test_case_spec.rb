# frozen_string_literal: true

require 'rails_helper'

describe TestCase do
  it 'Must have a problem statement' do
    test_case = build(:test_case, problem: nil)
    expect(test_case).to be_invalid
  end

  it 'Expect  one testcase result' do
    expect(TestCase.reflect_on_association(:test_case_result).macro).to eq :has_one
  end

  it 'created_by_id field cannot be empty' do
    test_case = build(:test_case, created_by_id: nil)
    expect(test_case).to be_invalid
  end

  it 'updated_by_id field cannot be empty' do
    test_case = build(:test_case, updated_by_id: nil)
    expect(test_case).to be_invalid
  end
end
