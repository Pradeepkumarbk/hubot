# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_API


icons = require './icons'
_  = require("underscore")
_s = require("underscore.string")
env = require("node-env-file")
env(".env")

module.exports = (robot) ->
  github = require("githubot")(robot)
  user = process.env.HUBOT_GITHUB_USER
  base_url = process.env.HUBOT_GITHUB_API
  token = process.env.HUBOT_GITHUB_ACCESS_TOKEN

  robot.respond /mule/, (msg) ->
    github.get "#{base_url}/users/#{user}/orgs?access_token=#{token}",(org) ->
      actionsSend = []
      for orgs in org
        orgs_name = "#{orgs.login}"
        actionsSend.push({'name':"#{orgs_name}",'text':"#{orgs_name}",'type':'button','style':'primary','value':"#{orgs_name}"})    
      msg.send {
        'replace_original': "false"
        'attachments':[{
          'text' : 'Hey! Click the Organisation details that you want '
          'fallback':'Test',
          'callback_id':'Button',
          'color': 'good',
          'actions': actionsSend
          }]
        }
         
  ASK_REGEX = ///                                  
    (\S+)?\s*
    help\s*
  ///i  

  parse_criteria = (message) ->
    [getorg, orgs] = message.match(ASK_REGEX)[1..]
    getorg: getorg,
    orgs: orgs

  robot.respond ASK_REGEX, (msg) ->
    criteria = parse_criteria msg.message.text
    string = msg.message.text.split " "
    github.get "#{base_url}/orgs/#{string[1]}/repos", (repos) ->
      actionsSend = []
      for repo in repos
        repo_name ="#{repo.name}"
        actionsSend.push({'text' :"#{repo_name}",'value':"#{repo_name}"})
      msg.send {
        'attachments':[{
            'text':"Select the Repo Detail you want under #{string[1]} Organization"
            'fallback':'Test',
            'callback_id':'menu',
            'color': 'good',
            'actions':[{
              'name':"Repos",
              'text':"Repository",
              'type':'select',
              'options':actionsSend
            }]
          }]
        }
