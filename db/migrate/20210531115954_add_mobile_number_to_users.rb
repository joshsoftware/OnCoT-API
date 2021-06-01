class AddMobileNumberToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mobile_number, :bigint
    add_column :users, :invitation_token, :string
    add_column :users, :invitation_sent_at, :datetime
    add_column :users, :invitation_accepted_at, :datetime
  end
end
