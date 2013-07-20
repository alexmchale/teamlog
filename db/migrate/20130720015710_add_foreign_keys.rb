class AddForeignKeys < ActiveRecord::Migration

  def up
    execute <<-SQL
      ALTER TABLE team_users
        ADD CONSTRAINT team_user_user_id_fk
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

      ALTER TABLE team_users
        ADD CONSTRAINT team_user_team_id_fk
        FOREIGN KEY (team_id)
        REFERENCES teams (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

      ALTER TABLE messages
        ADD CONSTRAINT message_user_id_fk
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

      ALTER TABLE messages
        ADD CONSTRAINT message_team_id_fk
        FOREIGN KEY (team_id)
        REFERENCES teams (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE messages DROP CONSTRAINT message_user_id_fk;
      ALTER TABLE messages DROP CONSTRAINT message_team_id_fk;
      ALTER TABLE team_users DROP CONSTRAINT team_user_user_id_fk;
      ALTER TABLE team_users DROP CONSTRAINT team_user_team_id_fk;
    SQL
  end

end
