ActiveAdmin.register Candidate do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :first_name, :last_name, :email, :is_profile_complete, :invite_status, :is_qualified, :organization_id, :role_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email, :is_profile_complete, :invite_status, :is_qualified, :organization_id, :role_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
