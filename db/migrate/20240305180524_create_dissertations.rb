class CreateDissertations < ActiveRecord::Migration[7.0]
  def change
    create_table :dissertations do |t|
      t.string :name
      t.string :title
      t.date :date
      t.string :link
      t.string :evaluations
      t.integer :kind
      t.string :year

      t.timestamps
    end
  end
end
