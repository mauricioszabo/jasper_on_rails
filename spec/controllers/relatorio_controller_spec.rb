require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RelatorioController do

  describe 'index' do
    context ' validation' do
      before :each do
        Relatorio.stub!(:new).and_return(mock_model(Relatorio, :to_pdf => nil))
      end

      it 'should require a format' do
        get :index, :relatorio => 'anything', :dados => 'anyagain'
        response.should have_text 'Formato não permitido'
        response.status.should =~ /403/
      end

      it 'should require data' do
        get :index, :relatorio => 'anything', :format => 'pdf'
        response.should have_text 'dados parameter is required'
        response.status.should =~ /403/
      end

    end

    context 'report generation' do
      it 'should create a new report object with given report, data and params' do
        Relatorio.should_receive(:new).with('report_name', 'my_data',
          {'p1' => '1', 'p2' => '2'}).
          and_return(mock_model(Relatorio, :to_pdf => nil))
        get :index, :relatorio => 'report_name', :format => 'pdf',
          :dados => 'my_data', :report_params => {'p1' => '1', 'p2' => '2'}
      end

      it 'should call to_#{format} on report object' do
        mock_report = mock_model(Relatorio)
        Relatorio.stub!(:new).and_return(mock_report)

        mock_report.should_receive(:to_pdf)
        get :index, :relatorio => 'report_name', :format => 'pdf', :dados => 'my_data'

        mock_report.should_receive(:to_ods)
        get :index, :relatorio => 'report_name', :format => 'ods', :dados => 'my_data'

        mock_report.should_receive(:to_docx)
        get :index, :relatorio => 'report_name', :format => 'docx', :dados => 'my_data'
      end
    end
  end

end

