# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  role = Role.find_or_create_by!(name: 'Admin')
  organization = Organization.find_or_create_by(name: 'Josh Software', email: 'josh@joshsoftware.com',
                                                contact_number: '123456789')
  user = User.find_or_create_by(first_name: 'Admin', email: 'admin@example.com',
                                role_id: role.id, organization_id: organization.id)
  user.password = 'josh@123'
  user.save
  drive = Drive.find_or_create_by(name: 'Josh Drive', start_time: DateTime.now + 1.hour, end_time: DateTime.now + 1.day,
                                  organization_id: organization.id, duration: 60, created_by_id: user.id,
                                  updated_by_id: user.id)
  problem = Problem.find_or_create_by(title: 'Add numbers', description: 'return sum of two numbers', created_by_id: user.id,
                                      updated_by_id: user.id, organization_id: organization.id)
  test_case = TestCase.find_or_create_by(input: '1 2', output: '3', marks: 2, problem_id: problem.id, updated_by_id: user.id,
                                         created_by_id: user.id)
end
