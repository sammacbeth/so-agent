os = require 'os'

module.exports = (callback) ->
	status = 
		uptime: os.uptime()
		memory:
			free: os.freemem()
			total: os.totalmem()
		load: os.loadavg()
	callback(null, status)
