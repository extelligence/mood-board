###
 GET home page.
###

fs = require('fs')
path = require('path')

UPLOAD_BASEPATH = './public/upload/'

exports.project = (req, res) ->
  project = req.params.project
  console.log("project:#{project}")
  if project.indexOf("favicon.ico") >= 0
      console.log("favicon")
      res.send(404)
  else
    upPath = path.normalize(UPLOAD_BASEPATH + project);
    console.log(upPath)
    if not path.existsSync(upPath)
      res.render('index',{title:project, images:[]})
    else
      fs.readdir(upPath, (error, files) ->
        images = []
        for name in files
          if name.indexOf(".") != 0
            images.push "upload/#{project}/#{name}"
        console.log("files:#{images}")
        res.render('index',{title:project, images:images})
      )


exports.upload = (req, res) ->
  console.log("upload")
  upfile = req.files.upfile
  project = req.params.project
  upPath = path.normalize(UPLOAD_BASEPATH + project)
  if upfile?.size != 0
    console.log(upfile)
    if not path.existsSync(upPath)
      fs.mkdirSync(upPath)
    suffix = upfile.name.split(".").pop()
    fs.renameSync(upfile.path, upPath + "/" + new Date().getTime() + "." + suffix )
  res.redirect("/#{project}")

exports.del = (req, res) ->
  console.log("delete")
  project = req.params.project
  target_filename = path.basename(req.body.target)
  deletePath = path.normalize(path.join(UPLOAD_BASEPATH,project,target_filename))
  console.log("deletePath:#{deletePath}")
  if path.existsSync(deletePath)
    console.log("deletePath->:#{deletePath}")
    fs.unlinkSync(deletePath)
    res.send()
  else
    res.send("not found",404)
