express = require('express')
routes = require('./routes')

app = module.exports = express.createServer();

app.configure(->
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(app.router)
    app.use(express.static(__dirname + '/public'))
    app.use(express.favicon())
    app.use(express.bodyParser({uploadDir: '/upload'}))
)

app.configure('development', ->
  app.use(express.errorHandler(
     dumpExceptions: true, showStack: true
  ))
)

app.configure('production', ->
  app.use(express.errorHandler())
)

app.get('/:project', routes.project)
app.post('/:project', routes.upload)
app.delete('/:project', routes.del)
app.get('/', routes.index)
app.post('/', routes.move)

app.listen(3001, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
)
