class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :campaign_id
      t.string :name
      t.string :validity
      t.string :choice
      t.boolean :status, default: :true
      t.timestamps
    end
  end
end
