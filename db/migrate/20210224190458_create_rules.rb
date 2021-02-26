class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :type_name
      t.text :description
      t.references :drive, null: false, foreign_key: true

      t.timestamps
    end
  end
end

