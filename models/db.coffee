mongo = require("mongodb")
CallbackSync = require('../utils/callback-sync.coffee')

class Model
	constructor: (values={}) ->
		@errors = {}
		@set values
		
	set: (values) ->
		for own key, value of @
			if values[key] and typeof values[key] != 'function' and key != 'errors'
				@[key] = values[key]
				
	valid: ->
		for own key, value of @errors
			return false
		true
		
	
		

module.exports = {
	init: (callback) ->
		client = new mongo.Db('node-blog', new mongo.Server("127.0.0.1", 27017, {}))
		client.open (err, client) ->
			console.log (err) if err
			posts = null
			comments = null
			
			sync = new CallbackSync 2, ->
				callback {
					posts: posts,
					comments: comments
				}
			
			require("./posts.coffee").init client, (_posts) ->
				posts = _posts 
				sync.trigger()
			require("./comments.coffee").init client, (_comments) -> 
				comments = _comments
				sync.trigger()
				
	Model: Model
}
