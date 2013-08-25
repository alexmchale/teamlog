class DropTeamAndUserFromMessages < ActiveRecord::Migration

  def change
    remove_column :messages, :user_id
    remove_column :messages, :team_id
  end

end
