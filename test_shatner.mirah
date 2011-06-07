package org.shatner

import org.shatner.ShatnerBase
import javax.servlet.http.*
import java.util.HashMap
import java.util.concurrent.Callable
import java.io.PrintWriter

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.Assert


class SomeApp < ShatnerBase
  def initialize : void
    super
    2
  end

  get '/' do
    'bananas'
  end
end

class SomeAppWoInitializer < ShatnerBase
  get '/' do
    'bananas'
  end
end

class SomeAppWithPost < ShatnerBase
  post '/' do
    'bananas'
  end
end
  
class FakeServletRequest; implements HttpServletRequest
  def initialize
  end
  def getPathInfo : String
    "/"
  end
end


class FakeServletResponse; implements HttpServletResponse
def initialize
end
def getWriter
  PrintWriter.new System.err
end
end

class SinatraCloneTest
/*  macro def test(name, &block)
    test_name = "test_" + name.string_value.replaceAll(" ", "_")
m = quote { def `"bar"`;puts "aoeu";end}
#puts MethodDefinition(m).child_nodes
puts m
import org.junit.Test
    node = quote do
      import org.junit.Test
      $Test
      def test_name #`test_name`:void
       # `block.body`
"aoeu"
      end
    end
puts node
puts node.child_nodes
puts "==============================="
#quote {nil}
node
  end
#
  test "doGet prints hello world" do
*/
  $Test
  def test_doGet_prints_hello_world : void
    app = SomeApp.new
    req = FakeServletRequest.new
    resp = FakeServletResponse.new
    app.doGet(req,resp)
    #assert resp something
  end

  $Test
  def test_doPost_prints_hello_world : void
    app = SomeAppWithPost.new
    req = FakeServletRequest.new
    resp = FakeServletResponse.new
    app.doPost(req,resp)
    #assert resp something
  end

end