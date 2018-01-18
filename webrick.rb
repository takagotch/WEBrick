require 'webrick'

srv = WEBrick::HTTPServer.new({
  DocumentRoot: './',
  BindAddress: IPaddr,
  Port: Port,
})

srv.start

#srv.mount('/', WEBrick::HTTPServlet::FileHandler, 'index.html')
srv.mount_proc '/' do |req, res|
  File.open("index.html") do |f|
    res.body = f.read
  end
#   res.body = req.query['a']
end

srv.mount('/cgi', WEBrick::HTTPServlet::CGIHandler, './cgi.rb')

#http s
require 'webrick'
root = File.expand_path '/public_html'
server = WEBrick::HTTPServer.new :Port => 8080, :DocumentRoot => root

trap 'INT' do server.shutdown end
server.start

server.mount_proc '/' do |req, res|
  res.body = 'hello!'
end

class Simple < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    status, content_type, body = do_stuff_with request

    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = 'Hello!'
  end
end

server.mount '/simple', Simple

#virtual host
server = WEBrick::HTTPServer.new
vhost = WEBrick::HTTPServer.new :ServerName => 'vhost.example',
	                        :DoNotListen => true,
vhost.mount '/',
server.virtual_host vhost

#https
require 'webrick'
require 'webrick/https'

cert_name = [
  %w[CN localhost],
]
server = WEBrick::HTTPServer.new(Port => 8080,
				:SSLEnable => true,
				:SSLCertName => cert_name)

#
require 'webrick'
require 'webrick/https'
require 'openssl'

cert = OpenSSL::X509::Certficate.new File.read '/path/to/cert.pem'
pkey = OpenSSL::PKey::RSA.new File.read '/path/to/pkey.pem'

server = WEBrick::HTTPServer.new(:Port => 8080,
				 :SSLEnable => true,
				 :SSLCertificate => cert,
				 :SSLPrivateKey => pkey)

#
require 'webrick'
require 'webrick/httpproxy'

proxy = WEBrick::HTTProxyServer.new :Port => 8080

trap 'INT' do proxy.shoutdown end

#
sockets = WEBrick::Utils.create_listeners nil, 80
WEBrick::Utils.su 'www'

#server = WEBrick::HTTPServer.new :DoNotListen => true
server.listers.replace sockets

#
log_file = File.open '/var/log/webrick.log', 'a+'
log = WEBrick::Log.new log_file

#
access_log = [
  [log_file, WEBrick::AccessLog::COMBINED_LOG_FORMAT],
]
server = WEBrick::HTTPServer.new :Logger => log, :AccessLog => access_log

#trap 'HUP' do log_file.reopen '/path/to/webrick.log', 'a+'

