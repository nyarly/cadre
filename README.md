# Cadre
### All your tools working together

The goal of Cadre is to provide bridges between development tools to enhance their utility.

Currently, it includes:

* A libnotify RSpec formatter, so that long spec runs aren't completely wasted time.
* A vim quickfix formatter, so that you can jump through the backtraces of your rspec fails
* A vim coverage indicator, so that you can see what code has coverage as you edit.

### Getting started

Add cadre to your working enviroment.  Either:

    gem install cadre

or add

    gem 'cadre'

to your Gemfile

Run:

   cadre how_to

for the current explanation of how to set the thing up

### Nota Mucho Bene

This thing has atrocious tests. As in: none at all. The way RSpec and Simplecov
set up their plugins, plus the interaction with the filesystem make it
particularly challenging. Normally I wouldn't release software like this, but
I'm finding it useful in daily work.

### New ideas

The basic requirements to add a feature to Cadre is that:

* useful to developers - this is the fuzziest requirement. All the Cadre tools
  started from the thought "wouldn't it be cool if..."

* at least two existing tools are involved. Ideas to make Vim more useful?
  Great, but unless you're bridging to another application, probably best just
  to write a vim plugin. RSpec configuration? Different gem.

* the tools are both local apps. I'm less wed to this one: it seems obvious
  that there would be value in e.g. github+pivotal mashups. I'm just not sure
  they belong on each dev's machine.

Those granted, I'd love for Cadre to grow into a freewheeling toolkit of useful
integrations.
