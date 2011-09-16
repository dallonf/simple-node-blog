Post = require('../models/posts.coffee').Post
Comment = require('../models/comments.coffee').Comment

module.exports = {
	init: (app, db) ->
	
		app.get '/', (req, res) ->
			db.posts.getAllPosts (results) ->
				res.render 'index', {
					title: "My blog",
					posts: results
				}
			
		app.get '/add', (req, res) ->
			post = new Post()
			res.render 'edit_post', {
					title: "My blog - Add post",
					post: post
				}
				
		app.post '/add', (req, res) ->
			post = new Post(req.body)
			if post.valid()
				db.posts.insertPost post, ->
					res.redirect '/'
			else
				res.render 'edit_post', {
					title: "My blog - Add post",
					post: post
				}
				
		app.get '/view/:id', (req, res) ->
			newComment = new Comment()
			db.posts.getPost req.param('id'), (post) ->
				res.render 'view_post', {
					title: post.title,
					post: post,
					newComment: newComment
				}
}
