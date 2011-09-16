Model = require('./db.coffee').Model
		
class Comment extends Model
	constructor: (values = {}) ->
		@_id = null
		@date_posted = new Date()
		@author = ""
		@body = ""
		super values
		
	valid: ->
		@errors = {}
		if not @author
			@errors['author'] = "Author is required"
		if not @body
			@errors['body'] = "Body is required"
		super

createService = (collection) -> {
	insertComment: (comment, postId, callback) ->
		debugger
		collection.update { _id: new collection.db.bson_serializer.ObjectID(postId) },
			{ '$push': { comments: comment } }, {safe: true}, (err) ->
				console.log err if err
				callback()
			
				
}	

module.exports = {
	init: (client, callback) ->
		client.collection "posts", (err, collection) ->
			console.log err if err
			callback createService(collection)
	Comment: Comment
}
