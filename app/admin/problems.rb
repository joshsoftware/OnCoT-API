ActiveAdmin.register Problem do
  permit_params do
    permitted_params = params.permit(:title, :description, :organization_id)
    permitted_params.merge!(created_by_id: current_admin_user.id, updated_by_id: current_admin_user.id)
  end
end
