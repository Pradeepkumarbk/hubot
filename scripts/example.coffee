# Description:
#   Example scripts for you to examine and try out.

module.exports = (robot) ->

   robot.hear /hi/i, (res) ->
     res.send "hello"
  
   robot.respond /sleep it off/i, (res) ->
     robot.brain.set 'totalSodas', 0
     res.reply 'zzzzz'