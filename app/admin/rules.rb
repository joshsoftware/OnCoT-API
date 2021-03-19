# frozen_string_literal: true

ActiveAdmin.register Rule do
  permit_params :type_name, :description, :drive_id
end
