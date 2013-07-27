class AddUniqueIndexToTeamMembers < ActiveRecord::Migration

  def up
    execute <<-SQL
      DELETE FROM team_users WHERE id NOT IN ( SELECT MIN(id) FROM team_users GROUP BY team_id, user_id );
      CREATE UNIQUE INDEX unique_team_members ON team_users (team_id, user_id);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX unique_team_members;
    SQL
  end

end
