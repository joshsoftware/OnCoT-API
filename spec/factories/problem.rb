# frozen_string_literal: true

FactoryBot.define do
  factory :problem, class: Problem do
    title { 'Valid Parentheses' }
    description do
      'Given a string s containing just the characters (, ), {, },
      [ and ], determine if_the the input string is valid. An input string is valid
      Open brackets must be closed by the same type of brackets. Open brackets
      must be closed in the correct order.

      Example 1:

      Input: s = ()
      Output: true
      Example 2:

      Input: s = ()[]{}
      Output: true
    '
    end
  end
end
