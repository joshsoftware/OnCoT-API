# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  # role = Role.find_or_create_by!(name: 'Admin')
  # organization = Organization.find_or_create_by(name: 'Josh Software', email: 'josh@joshsoftware.com',
  #                                               contact_number: '123456789')
  # user = User.find_or_create_by(first_name: 'Admin', email: 'admin@example.com',
  #                               role_id: role.id, organization_id: organization.id)
  # user.password = 'josh@123'
  # user.save
  # drive = Drive.find_or_create_by(name: 'Josh Drive', start_time: DateTime.now + 1.hour, end_time: DateTime.now + 1.day,
  #                                 organization_id: organization.id, duration: 60, created_by_id: user.id,
  #                                 updated_by_id: user.id)
  # problem = Problem.find_or_create_by(title: 'Add numbers', description: 'return sum of two numbers', created_by_id: user.id,
  #                                     updated_by_id: user.id, organization_id: organization.id)
  # test_case = TestCase.find_or_create_by(input: '1 2', output: '3', marks: 2, problem_id: problem.id, updated_by_id: user.id,
  #                                        created_by_id: user.id)

  ["If test Stops due to power failure or system shut down or any other scenario,
    Follow exactly same procedure, with exactly same name and email-id in registration
    page that was previously used to start the test and in exactly same OS & Browser as
    mentioned above to restart the test.",
    "Do not press browser refresh or back button while taking the test. The test will stop
    & it will not allow you to restart",
    " Do not open questions on Multiple Windows. The test will stop & it will not allow you to restart",
    "Use of calculators/mobile phones or any other electronic gadgets is not permitted.",
    "It is mandatory to keep your video camera on during the test",
    "Any attempt to open calculator, use short-cut keys like CLT, ALT, TAB etc.
    In the test window will stop the test & it will not allow you to restart",
    "The testing interface has overall timer running on it. The test will stop
      if your overall time lapses. Submit your solution before the overall timer elapses.
      If you don't submit the code before the overall timer elapses, then you will be
      awarded 0 in the problem.",
    "Compiling the code at least once is mandatory for your code to be compiled and evaluated.
      Please click on “Submit” button at least once before the overall time elapses.
      The failure to do so will result in zero marks since your code will not be compiled
      and evaluated by the system."].each do |desc|
      Rule.find_or_create_by(description: desc, drive: Drive.first)
    end

end
