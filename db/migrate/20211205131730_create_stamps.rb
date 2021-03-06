class CreateStamps < ActiveRecord::Migration[6.1]
  def change
    create_table :stamps do |t|
      t.string :key
      t.string :name
      t.string :back_image
      t.string :front_image
      t.string :activation_key
      t.string :color

      t.timestamps
    end
  end
end
