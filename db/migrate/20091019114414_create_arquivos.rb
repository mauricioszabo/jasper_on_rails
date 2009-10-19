class CreateArquivos < ActiveRecord::Migration
  def self.up
    create_table :arquivos do |t|
      t.references :relatorio
      t.string :tipo
      t.string :content_type
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :arquivos
  end
end
