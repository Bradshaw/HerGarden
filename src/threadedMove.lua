local srv = {
	ip = "192.168.1.29",
	port = "3000"
}
local http = require("socket.http")
--local srv = require("httpSettings")
local channel = love.thread.getChannel("http")
local msg = channel:demand()
if type(msg)=="table" then
	local url = msg.url
	local post = msg.post
	http.request("http://"..srv.ip..":"..srv.port.."/"..url, 'json='..post)
else
	http.request("http://"..srv.ip..":"..srv.port.."/"..msg)
end