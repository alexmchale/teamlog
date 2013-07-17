class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user
      t.references :team
      t.text :content

      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :team_id
  end
end
