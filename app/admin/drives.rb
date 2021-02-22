ActiveAdmin.register Drive do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  

  permit_params do
    permitted_params = params[:drive].permit(:name, :description, :start_time, :end_time, :organization_id)
    permitted_params.merge!(created_by_id: current_admin_user.id, updated_by_id: current_admin_user.id )
  end
end
