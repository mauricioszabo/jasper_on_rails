require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RelatorioController do

  describe 'routing' do
    it '/relatorio/report-name.format to index' do
      {:get => "/relatorio/students.odt"}.should route_to(
        :controller => 'relatorio', :action => 'index',
        :relatorio => 'students', :format => 'odt')
    end
  end

end

