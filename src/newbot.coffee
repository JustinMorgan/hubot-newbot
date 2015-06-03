# Description:
#   Spins up a new, temporary hubot script in memory.
#
# Dependencies:
#   coffee-script
#   swiss-army-eval
#
# Commands:
#   hubot newbot FooBot /foo/i (msg) -> msg.send "bar" - Creates a NewBot named FooBot that responds "bar" to the command "hubot foo".
#   hubot listenbot FooBot /foo/i (msg) -> msg.send "bar" - Creates a NewBot named FooBot that sends "bar" whenever a message includes "foo".
#   hubot killbot FooBot -  Deletes FooBot by name.
#   hubot list newbots -  Lists names of running newbots.
#   hubot showbot FooBot - Shows the regex and CoffeeScript body of FooBot.
#   hubot showbot FooBot --debug - Debug mode: Shows the regex and compiled JavaScript for FooBot.
#
# Author:
#   JustinMorgan@GitHub
#
sae = require "swiss-army-eval"
coffee = sae.bind null, "CoffeeScript"
regex = sae.bind null, "regex"

clean = (name) -> name?.toLowerCase?().trim()

# todo: test persistence behavior, consider using robot.brain.data
newbots = {}
  
class NewBot    
  compile = (code) ->
    obj = coffee(code) 
    if typeof obj is "function"
      obj
    else 
      (msg) -> msg.send obj
      
  constructor: (name, @pattern, @code) ->
    @name = clean name
    @regex = regex @pattern, "i"
    @func = compile @code 
    
  attach: (robot, botType) ->
    if newbots[@name]? 
      throw "I've already got a bot called #{@name}!"
    else 
      newbots[@name] = this    
    
    # We wrap @func in another function so we can easily kill it from the @destroy method
    robot[botType] @regex, (msg) => @func(msg)
    
  destroy: ->
    @func = ->
    delete newbots[@name]


module.exports = (robot) -> 
  robot.respond /(newbot|listenbot) (\S+),? \/(.*?)\/i?,? (.*)/i, (msg) ->
    if msg.match.length < 5 
      return msg.send "That's not enough parameters. I need a name, a pattern, and some code."
      
    [style, name, pattern, code] = msg.match[1..]
    
    try
      botType = {newbot:"respond", listenbot:"hear"}[style]
      bot = new NewBot name, pattern, code
      bot.attach robot, botType
      msg.send "i maked u a #{bot.name}!"
    catch e
      msg.send e
  
  robot.respond /list newbots/i, (msg) ->
    bots = ("- #{name}: /#{bot.pattern}/i" for own name, bot of newbots)
    msg.send "Active NewBots: \n" + bots.join "\n"
  
  robot.respond /killbot (.*)/i, (msg) ->
    name = clean msg.match[1]
    if newbots[name]? 
      newbots[name].destroy?()
      msg.send "i maked u a #{name}...but i eated it."
    else
      msg.send "#{name}? Never heard of it."

  robot.respond /showbot (.*?)( --debug)?$/i, (msg) ->
    name = clean msg.match[1]
    bot = newbots[name]
    if bot?
      result = """
        Name: #{name}
        Pattern: /#{bot.pattern}/i, 
        Code: #{bot.code}"""
      if msg.match[2] 
        result += "\nCompiled JS: #{coffee bot.code}"
      msg.send result
    else
      msg.send "#{name}? Never heard of it."