# frozen_string_literal: true

ActiveAdmin.register Drive do
  actions :all, except: [:destroy]
  permit_params do
    permitted = %i[name description start_time end_time created_by_id updated_by_id organization_id duration]
    if params['drive'].present?
      params['drive']['updated_by_id'] = current_user.id
      params['drive']['created_by_id'] = current_user.id
    end

    permitted
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
      f.input :start_time
      f.input :end_time
      f.input :organization
      f.input :duration
    end
    f.actions
  end
end
