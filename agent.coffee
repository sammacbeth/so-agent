## SO-Agent main.
async = require 'async'
rest = require 'restler'
config = require './config'

# collect required plugins
plugins = {}
config.plugins.forEach (plugin) ->
	try
		plugins[plugin] = require "./plugins/#{plugin}"
	catch error
		console.log "Error: could not load plugin (#{plugin}), #{error}"
		false

postback = () ->
	# get payload data from plugins
	async.parallel plugins, (err, data) ->
		if err?
			console.log "Error generating payload: #{err}"
		data.agentKey = config.key
		payload =
			payload: JSON.stringify data
		console.log "Generated payload:"
		console.log data
		# post data to SO
		rest.post(config.soUrl, { data: payload }).on 'complete', (data, response) ->
			console.log "Postback sent, response was: #{response.statusCode}"

# run once if in cron mode, on a 1 minute interval otherwis
if config.cron
	postback()
else
	setInterval postback, 60000
