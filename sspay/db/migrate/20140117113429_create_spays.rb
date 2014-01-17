class CreateSpays < ActiveRecord::Migration
  def change
    create_table :spays do |t|

      t.timestamps
    end
  end
end
