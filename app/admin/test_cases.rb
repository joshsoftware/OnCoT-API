ActiveAdmin.register TestCase do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :input, :output, :marks, :problem_id, :created_by_id, :updated_by_id

  permit_params do
    permitted_params = params.permit(:input, :output, :marks, :problem_id)
    permitted_params.merge!(created_by_id: current_admin_user.id, updated_by_id: current_admin_user.id)
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:input, :output, :marks, :problem_id, :created_by_id, :updated_by_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
