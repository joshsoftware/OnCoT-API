ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :first_name, :last_name, :email, :password, :organization_id, :role_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email, :password, :organization_id, :role_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :password
    column :organization_id
    column :role_id

    actions
  end

  filter :first_name
  filter :email

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :organization_id, :as => :select, :collection => Organization.all.collect {
                                |organization| [organization.name, organization.id] }
      f.input :role_id, :as => :select, :collection => Role.all.collect {
                                |role| [role.name, role.id] }
    end
    f.actions
  end

end
