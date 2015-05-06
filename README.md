# Hubot: NewBot

A Hubot script that spawns new Hubot scripts on the fly. Yo dawg.

## Installation

- Add `hubot-newbot` to your Hubot's `package.json`
- Add `hubot-newbot` to your Hubot's `external-scripts.json`
- Run `npm install`


## Commands

```
hubot newbot FooBot /foo/i (msg) -> msg.send "bar"    # Creates a NewBot named FooBot that responds "bar" to the command "hubot foo".
hubot listenbot FooBot /foo/i (msg) -> msg.send "bar" # Creates a NewBot named FooBot that sends "bar" whenever a message includes "foo".
hubot killbot FooBot                                  # Deletes FooBot by name.
hubot list newbots                                    # Lists names of running newbots.
hubot showbot FooBot                                  # Shows the regex and CoffeeScript body of FooBot.
hubot showbot FooBot --debug                          # Debug mode: Shows the regex and compiled JavaScript for FooBot.
```

## License

NewBot is licensed under the [MIT][mit] license.

[mit]: http://opensource.org/licenses/mit-license.php
