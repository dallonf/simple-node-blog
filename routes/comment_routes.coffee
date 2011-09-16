Comment = require('../models/comments.coffee').Comment

module.exports = {
	init: (app, db) ->
	
		app.post '/comment/add/:id', (req, res) ->
			comment = new Comment(req.body)
			if comment.valid()
				db.comments.insertComment comment, req.param('id'), ->
					res.redirect "/view/#{req.param('id')}"
			else
				db.posts.getPost req.param('id'), (post) ->
					res.render "view_post", {
						title: post.title,
						post: post,
						newComment: comment
					}
				
}
