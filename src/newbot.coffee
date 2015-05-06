# Description:
#   Spins up a new, temporary hubot script in memory.
#
# Dependencies:
#   coffee-script
#   swiss-army-eval
#
# Commands:
#   newbot FooBot /foo/i (msg) -> msg.send "bar" - Creates a NewBot named FooBot that responds "bar" to the command "hubot foo".
#   listenbot FooBot /foo/i (msg) -> msg.send "bar" - Creates a NewBot named FooBot that sends "bar" whenever a message includes "foo".
#   killbot FooBot -  Deletes FooBot by name.
#   list newbots -  Lists names of running newbots.
#   showbot FooBot - Shows the regex and CoffeeScript body of FooBot.
#   showbot FooBot --debug - Debug mode: Shows the regex and compiled JavaScript for FooBot.
#
# Author:
#   JustinMorgan@GitHub
#
compile = require "swiss-army-eval"
coffee = compile.bind null, "CoffeeScript"
regex = compile.bind null, "regex"

clean = (name) -> name?.toLowerCase?().trim()

#todo: test persistence behavior, consider using robot.brain.data
newbots = {}
  
class NewBot
  constructor: (name, @pattern, @code) ->
    @name = clean name
    @regex = regex @pattern, "i"
  get: ->
    @func ?= coffee(@code)
  attach: (robot, style = "newbot") ->
    @get() #make sure it compiles
    if newbots[@name]? 
      throw "I've already got a bot called #{@name}!"
    newbots[@name] = this
    botType = {newbot:"respond", listenbot:"hear"}[style]
    robot[botType] @regex, (msg) => @get?()?(msg)
  destroy: ->
    @get = ->
    delete newbots[@name]


module.exports = (robot) -> 
  robot.respond /(newbot|listenbot) (\S+),? \/(.*?)\/i?,? (.*)/i, (msg) ->
    if msg.match.length < 5 
      return msg.send "That's not enough parameters. I need a name, a pattern, and some code."
      
    [style, name, pattern, code] = msg.match[1..]
    
    try
      bot = new NewBot name, pattern, code
      bot.attach robot, style
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
      result = if msg.match[2] then (coffee bot.code) else bot.code
      msg.send "#{name}: /#{bot.pattern}/i, #{result}"
    else
      msg.send "#{name}? Never heard of it."