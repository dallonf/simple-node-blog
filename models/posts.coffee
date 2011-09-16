Model = require('./db.coffee').Model
Comment = require('./comments.coffee').Comment

class Post extends Model
	constructor: (values = {}) ->
		@_id = null
		@title = ""
		@body = ""
		@author = ""
		@comments = []
		values.comments = (new Comment(commentData) for commentData in values.comments) if values.comments
		super values
		
	valid: ->
		@errors = {}
		if not @title
			@errors['title'] = "Title is required"
		if not @body
			@errors['body'] = "Body is required"
		if not @author
			@errors['author'] = "Author is required"
		super


createService = (collection) -> {
		getAllPosts: (callback) ->
			collection.find().toArray (err, results) ->
				callback (new Post(result) for result in results)
			
		insertPost: (post, callback) ->
			collection.insert post, {safe: true}, (err) ->
				console.log err if err
				callback()
				
		getPost: (id, callback) ->
			debugger
			oid = new collection.db.bson_serializer.ObjectID(id)
			collection.findOne oid, (err, result) ->
				console.log err if err
				callback new Post(result)
				
	}	

module.exports = {
	init: (client, callback) ->
		client.collection "posts", (err, collection) ->
			console.log err if err
			callback createService(collection)
	Post: Post
}
