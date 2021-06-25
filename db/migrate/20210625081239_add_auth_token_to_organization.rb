class AddAuthTokenToOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :auth_token, :string
  end
end
