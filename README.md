# hubot-newbot

A Hubot script that spawns new Hubot scripts on the fly. 

![Yo dawg.][yodawg]

## Installation

1. Run `npm install --save hubot-newbot` (the `--save` is optional).
2. Add `hubot-newbot` to your Hubot's `external-scripts.json`.

## NewBot anatomy

NewBots are named, temporary, in-memory mini-bots that work just like a permanent Hubot script. You create them with three ingredients:

- A unique name,
- A regex to listen for,
- A CoffeeScript function literal.

They last until you kill them or your Hubot app restarts; then they're gone forever. They're a good way to try out a Hubot script idea without saving it to a file and restarting Hubot.

## NewBots and ListenBots

There are two kinds of bots you can create: standard NewBots and ListenBots. Standard NewBots respond only to direct commands, so they'll only go off when a chat message **starts** with `hubot <command>`. ListenBots look for keywords embedded anywhere in a chat message.

## Hubot chat commands

```
hubot newbot FooBot /foo/i (msg) -> msg.send "bar"    # Creates a NewBot named FooBot that responds "bar" to the command "hubot foo".
hubot listenbot FooBot /foo/i (msg) -> msg.send "bar" # Creates a ListenBot named FooBot that responds "bar" to any chat message that includes the string "foo".
hubot killbot FooBot                                  # Deletes FooBot by name.
hubot list newbots                                    # Lists names of running newbots.
hubot showbot FooBot                                  # Shows the regex and CoffeeScript body of FooBot.
hubot showbot FooBot --debug                          # Debug mode: Shows the regex and compiled JavaScript for FooBot.
```


## About

- GitHub: https://github.com/JustinMorgan/hubot-newbot
- NPM: https://www.npmjs.com/package/hubot-newbot
- Author: Justin Morgan (https://github.com/JustinMorgan)
- License: NewBot is licensed under the [MIT][mit] license.

[mit]: http://opensource.org/licenses/mit-license.php
[yodawg]: https://i.imgur.com/DFpKOjO.jpg
