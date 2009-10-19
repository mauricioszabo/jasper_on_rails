class CreateRelatorios < ActiveRecord::Migration
  def self.up
    create_table :relatorios do |t|
      t.string :nome
      t.string :relatorios
      t.string :modelos

      t.timestamps
    end
  end

  def self.down
    drop_table :relatorios
  end
end
