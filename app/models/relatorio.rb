require 'jasper/jasperreports-3.6.0.jar'

Dir.entries("#{RAILS_ROOT}/lib/jasper/lib").each do |lib|
  require "jasper/lib/#{lib}" if lib =~ /\.jar$/
end

java_import Java::net::sf::jasperreports::engine::util::JRXmlUtils
java_import Java::net::sf::jasperreports::engine::query::JRXPathQueryExecuterFactory
java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager

class Relatorio
  DIR = "#{RAILS_ROOT}/relatorios"

  def initialize(modelo, dados)
    @modelo = "#{DIR}/#{modelo}.jasper"
    raise ArgumentError, "Arquivo #@modelo não existe." unless File.exist?(@modelo)

    documento = JRXmlUtils.parse(
      org.xml.sax.InputSource.new(
        java.io.StringReader.new(dados)
      )
    )

    @params = {
      JRXPathQueryExecuterFactory::PARAMETER_XML_DATA_DOCUMENT => documento
    }
  end

  def to_pdf
    fill = JasperFillManager.fill_report(@modelo, @params)
    pdf = JasperExportManager.export_report_to_pdf(fill)
    return String.from_java_bytes(pdf)
  end
end
