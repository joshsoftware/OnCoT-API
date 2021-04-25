class AddTotalMarksAndLangCodeToSubmission < ActiveRecord::Migration[6.1]
  def change
    add_column :submissions, :total_marks, :float, default: 0
    add_column :submissions, :lang_code, :integer
  end
end
