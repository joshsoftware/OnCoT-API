ActiveAdmin.register TestCase do
  actions :all, except: [:destroy]
  permit_params do
    permitted = %i[problem input created_by_id updated_by_id output marks]
    if params['testcase'].present?
      params['testcase']['updated_by_id'] = current_user.id
      params['testcase']['created_by_id'] = current_user.id
    end

    permitted
  end

  form do |f|
    f.inputs do
      f.input :problem
      f.input :input
      f.input :output
      f.input :marks

    end
    f.actions
  end
  
end
