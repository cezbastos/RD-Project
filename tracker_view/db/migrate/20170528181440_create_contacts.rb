class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :page
      t.datetime :access_datetime

      t.timestamps null: false
    end
    #execute "ALTER TABLE contacts ADD PRIMARY KEY (email,page);"
  end
end
