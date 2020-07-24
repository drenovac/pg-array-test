class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :surname
      t.string :first_name
      t.string :address, array: true, default: '{}'

      t.timestamps
    end
  end
end
