Hello. World. (on trinidad)
==============

This is a hello world app for Shatner.

It requires trinidad, the jruby tomcat wrapper.

To use it, compile shatner

    cd shatner
    bundle install
    rake compile

Then, compile this example.

    cd examples/hello_world
    rake compile

You should then be able to start a trinidad server
using the provided config

    trinidad -p 5678 --config
    
then just hit localhost:5678/, and you'll see hello world.