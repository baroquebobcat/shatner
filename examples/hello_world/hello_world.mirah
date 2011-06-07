package org.hello.world

import org.shatner.ShatnerBase

class HelloWorld < ShatnerBase
  get '/' do
    'hello. world.'
  end
end