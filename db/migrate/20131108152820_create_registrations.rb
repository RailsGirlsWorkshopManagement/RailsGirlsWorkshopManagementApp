class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :type
      
      t.string :firstname
      t.string :lastname
      t.string :email

      t.string :language
      t.string :last_attended
      t.integer :coding_level
      t.string :os
      t.text :other_languages

      t.boolean :project
      t.text :idea
      t.text :want_learn
      t.boolean :group
      t.string :join_group

      t.string :notes

      t.timestamps
    end
  end
end
