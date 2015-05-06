# Description:
#   Allows hubot to run inline JS or CoffeeScript.
#
# Dependencies:
#   coffee-script
#   swiss-army-eval
#
# Commands:
#   !js <code> or !javascript <code>        - Evaluates inline JS and returns the result, if any.
#   !coffee <code> or !coffeescript <code>  - Evaluates inline CoffeeScript and returns the result, if any.
#
# Author:
#   JustinMorgan@GitHub
#
compile = require "swiss-army-eval" 

module.exports = (robot) -> 
  robot.hear /^!(js|javascript|coffee(?:script)?) (.*)/i, (msg) ->
    [lang, code] = msg.match[1..]
    try 
      msg.send (do compile lang, code).toString()
    catch e
      msg.send e