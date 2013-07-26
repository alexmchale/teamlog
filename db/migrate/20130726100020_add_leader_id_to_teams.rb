class AddLeaderIdToTeams < ActiveRecord::Migration

  def up
    execute <<-SQL
      ALTER TABLE teams ADD COLUMN leader_id INTEGER REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE;
      UPDATE teams SET leader_id = (SELECT id FROM users LIMIT 1);
      ALTER TABLE teams ALTER COLUMN leader_id SET NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE teams DROP COLUMN leader_id;
    SQL
  end

end
