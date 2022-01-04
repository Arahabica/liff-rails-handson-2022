class CreateImprints < ActiveRecord::Migration[6.1]
  def change
    create_table :imprints do |t|
      t.bigint :user_id, null: false
      t.references :stamp, null: false, foreign_key: true
      t.integer :status
      t.timestamp :stamped_at

      t.timestamps
    end
  end
end
