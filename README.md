== Cadre
==== All your tools working together

The goal of Cadre is to provide bridges between development tools to enhance their utility.

Currently, it includes:

A libnotify RSpec formatter, so that long spec runs aren't completely wasted time.
A vim quickfix formatter, so that you can jump through the backtraces of your rspec fails

A vim coverage indicator, so that you can see what code has coverage as you edit.

=== Nota Mucho Bene

This thing has atrocious tests. As in: none at all. The way RSpec and Simplecov
set up their plugins, plus the interaction with the filesystem make it
particularly challenging. Normally I wouldn't release software like this, but
I'm finding it useful in daily work.
