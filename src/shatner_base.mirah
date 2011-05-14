package org.shatner

import java.util.HashMap
import java.util.concurrent.Callable

import javax.servlet.http.*
import java.io.PrintWriter

import duby.lang.compiler.Node
import duby.lang.compiler.Body
#import duby.lang.compiler.Noop
import duby.lang.compiler.MethodDefinition
import duby.lang.compiler.ClassDefinition

class ShatnerBase < HttpServlet

  macro def get param, &block

# unless containing_class.instance_initializer_exists?
#   containing_class.body do
#     import java.util.HashMap
#     def initialize
#       @routes = HashMap.new
#     end
#   end
# end
# containing_class.instance_initializer << do
#   @routes[param]= Callable `block.body`
# end
  klass = ClassDefinition(nil)
  current = param.parent
  while current.parent !=nil
    current = current.parent
    break if current.getClass.getName.contains("ClassDefinition")
  end
  klass = ClassDefinition(current)


    #sometimes the class body is the body,
    #sometimes it's the child of the body
    if klass.body.child_nodes.get(0).getClass.getName.contains "Body"    
      klass_body = Body(klass.body.child_nodes.get(0))
    else    
      klass_body = Body(klass.body)
    end
    
    init_meth = MethodDefinition(nil)
    klass_body.child_nodes.each do |node|            
      if node.getClass.getName.contains("ConstructorDefinition") &&     
         Node(node).string_value.equals("initialize")
        init_meth = MethodDefinition(node)    
      end
    end
    if init_meth.nil?    
      init_body = quote do
        def initialize;nil;nil;end
      end
      klass_body << init_body
      init_meth = MethodDefinition(init_body)
    end
    
    if init_meth.getClass.getName.contains("Noop")
      init_body = quote do
        def initialize;end
      end
      klass_body << init_body
      init_meth = MethodDefinition(init_body)
    end
    
    Body(init_meth.body) << quote do
      add_callback_for_route `param` do
        result=`block.body`
        return result
      end
    end
    
    quote { nil }
  end
  
  def initialize
    puts "in sinatra clone base"
  end
  
  def add_callback_for_route route:String, runnable:Callable : void
    routes_to_runnables.put route, runnable
  end
  
  def callback_for_route route:String
    Callable(routes_to_runnables.get route)
  end
  
  def routes_to_runnables
    @routes ||= HashMap.new
  end
  
  def doGet(request, response)
    route = request.getContextPath
    puts "GET #{route}" #argh parsers "
    result =   callback_for_route(route).call
    puts "result :"
    puts result
    writer = response.getWriter
    writer.println result
    writer.close
    puts "done"
  end
end
