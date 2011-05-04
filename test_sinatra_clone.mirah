package org.nick

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.Assert

import java.io.PrintWriter
import java.util.HashMap

import javax.servlet.http.*
import duby.lang.compiler.Node
import duby.lang.compiler.Body
import duby.lang.compiler.MethodDefinition
import duby.lang.compiler.ClassDefinition

class SinatraCloneBase < HttpServlet

  macro def get param, &block

# unless containing_class.class_initializer_exists
#   containing_class.body do
#     import java.util.HashMap
#     def self.initialize
#       @routes = HashMap.new
#     end
#   end
# end
# containing_class.class_initializer << do
#   @routes[param]= Callable `block.body`
# end
    klass = ClassDefinition(param.parent.parent.parent.parent)

    st_init = MethodDefinition(nil)
    klass_body = Node(klass.body.child_nodes.get(0))
    klass_body.child_nodes.each do |node|
      if node.getClass.toString.contains("StaticMethodDefinition") &&
        Node(node).string_value.equals("initialize")
        st_init = MethodDefinition(node)
      end
    end
    
    adding_block = quote do
      puts "adding stuff, bitches"
      @routes ||= HashMap.new
      @routes.put `param`, "something"
    end

    Body(st_init.body) << adding_block
    
    quote { nil }
  end
    
    def doGet(request, response)
      puts request.getContextPath
      
    end
end

class SomeApp < SinatraCloneBase
def self.initialize : void
nil
1
end
  get '/' do
    'bananas'
  end
end

class FakeServletRequest; implements HttpServletRequest
def initialize
end
def getContextPath : String
"/"
end
end


class FakeServletResponse; implements HttpServletResponse
def initialize
end
def getWriter
PrintWriter.new System.out
end
end

class SinatraCloneTest
  macro def test(name, &block)
    test_name = "test_" + name.string_value.replaceAll(" ", "_")
    quote do
#      import org.junit.Test
#      $Test
      def `test_name`:void
        `block.body`
      end
    end
  end

  $Test
#test "doGet prints hello world" do
def test_foo:void
    app = SomeApp.new
    req = FakeServletRequest.new
    resp = FakeServletResponse.new
    
    app.doGet(req,resp)
  end
end