class AddMobileNumberToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :mobile_number, :string
  end
end

