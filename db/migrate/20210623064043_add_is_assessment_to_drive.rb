class AddIsAssessmentToDrive < ActiveRecord::Migration[6.1]
  def change
    add_column :drives, :is_assessment, :boolean
  end
end
