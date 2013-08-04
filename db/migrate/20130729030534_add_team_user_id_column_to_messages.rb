class AddTeamUserIdColumnToMessages < ActiveRecord::Migration

  def up
    execute <<-SQL
      ALTER TABLE messages ADD COLUMN team_user_id INTEGER REFERENCES team_users (id) ON DELETE CASCADE ON UPDATE CASCADE;
      UPDATE messages SET team_user_id = (SELECT id FROM team_users WHERE messages.team_id = team_users.team_id AND messages.user_id = team_users.user_id);
      ALTER TABLE messages ALTER COLUMN team_user_id SET NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE messages DROP COLUMN team_user_id;
    SQL
  end

end
