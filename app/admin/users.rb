# frozen_string_literal: true

ActiveAdmin.register User do
  actions :all, except: [:destroy]
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :organization_id, :role_id

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :organization_id
    column :role_id
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :organization
      f.input :role
    end
    f.actions
  end
end
