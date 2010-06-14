class RelatorioController < ApplicationController
  def index
    if params[:format].blank?
      render :text => "Formato não permitido", :status => :forbidden
      return
    end

    @relatorio = Relatorio.new(params[:relatorio], params[:dados].to_s)

    respond_to do |format|
      [:pdf, :xls, :rtf, :docx, :csv, :ods, :odt].each do |um_formato|
        format.send(um_formato) do
          render :text => @relatorio.send("to_#{um_formato}")
        end
      end
    end
  end
end

