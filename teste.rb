require 'net/http'

relatorio = 'alunos/Matriculas por Aluno.odt'
dados_relatorio = 'alunos.xml'

http = Net::HTTP.new('localhost', 3000)
get = Net::HTTP::Get.new("/relatorio/" + URI.escape(relatorio), nil)

get.form_data = { :dados => File.read(dados_relatorio) }
resp = http.request(get)

File.open("saida.odt", 'wb') { |f| f.print resp.read_body }
