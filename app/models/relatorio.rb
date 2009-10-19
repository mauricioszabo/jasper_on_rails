class Relatorio
  DIR_BASE = File.join(RAILS_ROOT, 'relatorios')

  #attr_reader :errors
  attr_accessor :nome, :modelos, :relatorios

  def initialize(params = {})
    params.symbolize_keys!
    @errors = {}

    self.nome = params[:nome]
    self.modelos = params[:modelos]
    self.relatorios = params[:relatorios]
  end

  def save
    return false unless valid?
  end

  def valid?
    @errors = { :nome => [], :relatorios => [] }
    nome_valido?
    nome_unico?
    relatorios_validos?

    if(@errors[:nome].empty? and @errors[:relatorios].empty?)
      return true
    else
      return false
    end
  end

  def error_on(campo)
    campo = campo.to_sym
    return @errors[campo] || []
  end

  private
  def nome_valido?
    @errors[:nome] << 'Nome é obrigatório' if nome.to_s == ''
  end

  def relatorios_validos?
    msg = 'É necessário informar ao menos um relatório'
    if(relatorios)
      @errors[:relatorios] << msg if relatorios.empty?
    else
      @errors[:relatorios] << msg
    end
  end

  def nome_unico?
    return if nome.to_s == ''
    existe = File.exists?(File.join(DIR_BASE, nome.to_s))
    @errors[:nome] << 'Nome precisa ser único' if(existe)
  end
end
