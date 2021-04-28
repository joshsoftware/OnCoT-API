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
  organization = Organization.find_or_create_by!(name: 'Josh Software', email: 'josh@joshsoftware.com',
                                                 contact_number: '123456789')
  user = User.find_or_create_by!(first_name: 'Admin', email: 'admin@example.com', role_id: role.id,
                                 organization_id: organization.id)
  drive = Drive.find_or_create_by!(name: 'Josh Drive', start_time: '2021-04-26 12:00:00', end_time: '2021-04-28 12:00:00',
                                   organization_id: organization.id, duration: 60, created_by_id: user.id,
                                   updated_by_id: user.id)
  problem = Problem.find_or_create_by!(title: 'Add numbers', created_by_id: user.id, updated_by_id: user.id,
                                       organization_id: organization.id)
end
