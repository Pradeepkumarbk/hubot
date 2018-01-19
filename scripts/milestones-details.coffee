# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_API


icons = require './icons'

module.exports = (robot) ->
  github = require("githubot")(robot)
  user = process.env.HUBOT_GITHUB_USER
  base_url = process.env.HUBOT_GITHUB_API
  token = process.env.HUBOT_GITHUB_ACCESS_TOKEN

  ASK_REGEX = ///                                 
    (\S+)?\s*
    milestones\s*
  ///i  

  parse_criteria = (message) ->
    [getmiles, miles] = message.match(ASK_REGEX)[1..]
    getmiles: getmiles,
    miles: miles

  robot.respond ASK_REGEX, (msg) ->
    criteria = parse_criteria msg.message.text
    string = msg.message.text.split " "
    github.get "#{base_url}/orgs/#{string[1]}/repos?access_token=#{token}", (repos) ->
      for repo in repos
        fullname = repo.full_name
        github.get "#{base_url}/repos/#{fullname}/milestones?access_token=#{token}", (milestones) ->
          for miles in milestones
            string = miles.html_url.split "/"
            msg.send ">>>#{icons.repo} #{string[3]}/#{string[4]} \n    
                  - Title :-                `#{miles.title}`\n    
                  - Labeled issues :-  `#{miles.open_issues}`\n
                  - State  :-            `#{miles.state}`\n
                  - Created at:-     `#{miles.created_at}`\n
                  - Updated on :-     `#{miles.updated_at}`\n
                  - Due date :-      `#{miles.due_on}`"
