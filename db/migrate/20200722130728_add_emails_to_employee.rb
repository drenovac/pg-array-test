class AddEmailsToEmployee < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :emails, :text, array: true, default: []
  end
end
