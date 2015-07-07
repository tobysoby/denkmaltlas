class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer :eid
      t.string :web
      t.text :adresse
      t.text :beschreibung
      t.text :bemerkung
      t.string :lat
      t.string :lng

      t.timestamps
    end
  end
end
