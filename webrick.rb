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

