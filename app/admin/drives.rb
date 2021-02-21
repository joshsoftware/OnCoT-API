ActiveAdmin.register Drive do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :start_time, :end_time, :created_by_id, :updated_by_id, :organization_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :start_time, :end_time, :created_by_id, :updated_by_id, :organization_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  

  permit_params :name, :description, :start_time, :end_time, :created_by_id, :updated_by_id, :organization_id

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :start_time
    column :end_time
    column :created_by_id
    column :updated_by_id
    column :organization_id

    actions
  end

  filter :name
  filter :organization_id

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :description
      f.input :start_time
      f.input :end_time
      f.input :created_by_id, :as => :select, :collection => User.all.collect {
                              |user| [user.name, user.id] }
      f.input :updated_by_id, :as => :select, :collection => User.all.collect {
                              |user| [user.name, user.id] }
      f.input :organization_id, :as => :select, :collection => Organization.all.collect {
                                |organization| [organization.name, organization.id] }
      
    end
    f.actions
  end
  
end
