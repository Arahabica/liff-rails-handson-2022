class CreateStamps < ActiveRecord::Migration[6.1]
  def change
    create_table :stamps do |t|
      t.string :key
      t.string :name
      t.string :back_image
      t.string :front_image

      t.timestamps
    end
  end
end
