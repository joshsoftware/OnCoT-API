ActiveAdmin.register Role do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :type
  #
  # or
  #
  # permit_params do
  #   permitted = [:type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :type
    
    actions
  end

  filter :type

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :type
    end
    f.actions
  end
  
end
