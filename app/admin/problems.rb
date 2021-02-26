ActiveAdmin.register Problem do
  actions :all, except: [:destroy]
  permit_params do
    permitted = [:title, :description, :created_by_id, :updated_by_id, :organization_id]
    if params["problem"].present?
      params["problem"]["updated_by_id"] = current_user.id
      params["problem"]["created_by_id"] = current_user.id
    end

    permitted
  end
  
  form do |f|
    f.inputs do 
      f.input :title
      f.input :description
      f.input :organization
    end
    f.actions        
  end
end
