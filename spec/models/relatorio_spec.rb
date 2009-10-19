require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Relatorio' do
  before do
    @validos = {
      :nome => "Um Nome",
      :relatorios => ['algo']
    }
  end

  it 'deve ser válido se for incluso todos os atributos' do
    @relatorio = Relatorio.new @validos
    @relatorio.should be_valid
  end

  it 'deve ser inválido se não tiver nome ou relatórios' do
    @relatorio = Relatorio.new
    @relatorio.should_not be_valid

    @relatorio.should have(1).error_on(:nome) 
    @relatorio.should have(1).error_on(:relatorios)
  end

  it 'deve ser inválido se o nome for duplicado' do
    @relatorio = Relatorio.new @validos
    @relatorio.save

    File.should_receive(:exists?).and_return(true)
    @relatorio = Relatorio.new @validos
    @relatorio.should_not be_valid
    @relatorio.should have(1).error_on(:nome)
  end
end
