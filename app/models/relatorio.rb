class Relatorio < ActiveRecord::Base
  validates_presence_of :nome
  validates_uniqueness_of :nome
end
