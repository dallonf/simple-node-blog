express = require('express')

app = express.createServer()

app.configure ->
	app.set 'views', __dirname + '/views'
	app.set 'view engine', 'jade'
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser() 
	app.use express.session({secret: "do a barrel roll"})
	app.use app.router
	app.use express.static(__dirname + '/public')
	
require('./models/db.coffee').init (db) ->
	require('./routes/post_routes.coffee').init app, db
	require('./routes/comment_routes.coffee').init app, db
	
	app.listen 3000
	console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"	




