ActiveAdmin.register Organization do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :email, :contact_number
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :email, :contact_number]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :email
    column :contact_number
    actions
  end
  filter :name
  filter :contact_number

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :email
      f.input :contact_number
    end
    f.actions
  end

  
end
