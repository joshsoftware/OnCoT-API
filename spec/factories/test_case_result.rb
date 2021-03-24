FactoryBot.define do
  factory :test_case_result, class: TestCaseResult do
    association :test_case
    association :submission
  end
end
