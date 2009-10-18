Dir.entries("#{RAILS_ROOT}/lib/jasper/lib").each do |f|
  require "lib/jasper/lib/#{f}" if f =~ /\.jar$/
end
require 'jasper/jasperreports-3.6.0.jar'

java_import Java::net::sf::jasperreports::engine::xml::JRXmlLoader
java_import Java::net::sf::jasperreports::engine::JasperManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager
java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::query::JRXPathQueryExecuterFactory
java_import Java::net::sf::jasperreports::engine::util::JRXmlUtils
java_import Java::net::sf::jasperreports::engine::util::JRLoader
java_import Java::net::sf::jasperreports::engine::util::xml::JRXPathExecuterFactory


class TesteController < ApplicationController
  DIR = RAILS_ROOT + "/../"

  def index
    arquivo = DIR + 'Alunos.jasper'
    dados = DIR + "alunos.xml"

    documento = JRXmlUtils.parse(JRLoader.get_location_input_stream(dados))
    params = { JRXPathQueryExecuterFactory::PARAMETER_XML_DATA_DOCUMENT => documento }
    fill = JasperFillManager.fill_report(arquivo, params)
    #pdf = JasperExportManager.export_report_to_pdf(fill)

    render :text => proc { |req, resp|
      resp.content_type = 'text/pdf'
      #resp.write "Hello, World\n"
      #resp.write resp.methods.sort.inspect

      pdf = JasperExportManager.export_report_to_pdf(fill)
      #pdf = JasperExportManager.export_report_to_pdf_stream(fill, resp)
      resp.write(pdf)
    }
  end

end
