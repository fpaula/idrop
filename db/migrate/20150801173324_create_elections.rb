class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :finish_date
      t.integer :category_id
      t.string :status

      t.timestamps null: false
    end
  end
end