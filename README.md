ruby-grapher
============

This is a library to record all dependecies in a ruby application between itself, standard lib and gems. Goal is to vizualize the recording in a graph.

TODO
----
- [x] return dependencies with two positions @done (14-03-11 22:04)
- [x] what to do with dependecies in blocks @done (14-03-13 21:42)
- [x] Keep track of the current position in the application @done (14-03-11 22:05)
- [x] Can record the call tree that starts in a block. @done (14-03-11 22:04)
- [x] Records path, line no, method and class. @done (14-03-11 22:04)
- [x] Keep count of how many time a call takes place @done (14-03-11 22:34)
- [] Match the current point to gem/application/core
  stdlib: `/lib/ruby/x.x.x/`
  gems: `/lib/ruby/gems/x.x.x/gems/<name>-<version>`
- [] Save a file that's a list of all calls between points
- [] When block raises, the tracers are not finalized correctly.
- [] Create a mode that can be used to record all calls in a webserver. It should not take a block, but should be turned on and off.
- [] Test dynamic/eval class creation.
- [] Test on a big code base.
- [] Investigate graping libary to use.
