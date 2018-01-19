# Event subscription

github = require("githubot")
base_url = process.env.HUBOT_GITHUB_API
module.exports = (robot) ->
  robot.router.post "/event-subs", (request, response) ->
    payload = request.body
    response.send "#{payload.challenge}"

# Interactive Response

  robot.router.post "/slack", (request, response) ->
    payload = JSON.parse(request.body["payload"])
    actions = payload["actions"]
    name = "#{actions[0]["name"]}"
    github.get "#{base_url}/orgs/#{name}/repos", (repos) ->
      actionsSend = []
      for repo in repos
        repo_name ="#{repo.name}"
        actionsSend.push({'text' :"#{repo_name}",'value':"#{repo_name}"})
      response.send {
        'replace_original': "false"
        'attachments':[{
            'text':"Select the Repo Detail you want under #{name} Organization"
            'fallback':'Test',
            'callback_id':'menu',
            'color': 'good',
            'actions':[{
              'name':"repository",
              'text':"Repository",
              'type':'select',
              'options':actionsSend
            }]
          }]
        }