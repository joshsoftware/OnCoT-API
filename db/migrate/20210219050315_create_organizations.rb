class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :description
      t.string :email
      t.string :contact_number

      t.timestamps
    end
  end
end
