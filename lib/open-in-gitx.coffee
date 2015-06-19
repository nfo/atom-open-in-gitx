exec = require("child_process").exec

module.exports =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'open-in-gitx:open', => @openApp()

  openApp: ->
    getRepo().then (repo) ->
      exec "open -a GitX.app #{repo.workingDirectory}" if repo?

# Get the repository of the current file or project if no current file
# Returns a {Promise} that resolves to a repository like object
getRepo = ->
  new Promise (resolve, reject) ->
    getRepoForCurrentFile().then (repo) -> resolve(repo)
    .catch (e) ->
      repos = atom.project.getRepositories().filter (r) -> r?
      if repos.length is 0
        console.log "No repos found"
        reolve()
      else
        resolve(repos[0].repo)

getRepoForCurrentFile = ->
  new Promise (resolve, reject) ->
    project = atom.project
    path = atom.workspace.getActiveTextEditor()?.getPath()
    directory = project.getDirectories().filter((d) -> d.contains(path))[0]
    if directory?
      project.repositoryForDirectory(directory).then (repo) ->
        submodule = repo.repo.submoduleForPath(path)
        if submodule?
          resolve(submodule.repo)
        else resolve(repo.repo)
      .catch (e) ->
        reject(e)
    else
      reject "no current file"
