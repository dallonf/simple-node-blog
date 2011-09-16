class CallbackSync
	constructor: (@count, @callback) ->
	
	trigger: ->
		@count--;
		if @count <= 0
			@callback()
			
module.exports = CallbackSync
