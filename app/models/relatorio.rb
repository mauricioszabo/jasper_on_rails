require 'tempfile'
require 'action_controller/uploaded_file'

Dir.entries("#{RAILS_ROOT}/lib/jasper").each do |lib|
  require "jasper/#{lib}" if lib =~ /\.jar$/
end

Dir.entries("#{RAILS_ROOT}/lib/jasper/lib").each do |lib|
  require "jasper/lib/#{lib}" if lib =~ /\.jar$/
end

require 'java'
java_import Java::net::sf::jasperreports::engine::util::JRXmlUtils
java_import Java::net::sf::jasperreports::engine::query::JRXPathQueryExecuterFactory
java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager
java_import Java::net::sf::jasperreports::engine::JRExporterParameter
java_import Java::org::xml::sax::InputSource
java_import Java::java::io::StringReader


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

  def to_html
    fill = JasperFillManager.fill_report(@modelo, @params)
    arq = ActionController::UploadedTempfile.new 'temp'
    arq.close

    JasperExportManager.export_report_to_html_file(fill, arq.local_path)
    arq.open
    dados = arq.read
    arq.close!

    return dados
  end

  require 'irb'

  def to_xls
    exportar_formato Java::net.sf.jasperreports.engine.export.JRXlsExporter.new
  end

  def to_csv
    exportar_formato Java::net.sf.jasperreports.engine.export.JRCsvExporter.new
  end

  def to_docx
    exportar_formato Java::net.sf.jasperreports.engine.export.ooxml.JRDocxExporter.new
  end

  def to_odt
    exportar_formato Java::net.sf.jasperreports.engine.export.oasis.JROdtExporter
  end

  def to_ods
    exportar_formato Java::net.sf.jasperreports.engine.export.oasis.JROdsExporter
  end

  def to_rtf
    exportar_formato Java::net.sf.jasperreports.engine.export.JRRtfExporter
  end

  private
  def exportar_formato(classe)
    fill = JasperFillManager.fill_report(@modelo, @params)
    string = java.io.ByteArrayOutputStream.new

    exporter = if classe.is_a?(Class) then classe.new else classe end

    exporter.set_parameter(JRExporterParameter::JASPER_PRINT, fill)
    exporter.set_parameter(JRExporterParameter::OUTPUT_STREAM, string)

    exporter.export_report
    return String.from_java_bytes(string.to_byte_array)
  end
end

