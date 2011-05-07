require 'ant'
require 'rubygems'
require 'mirah_task'

module Mirah::AST
  class MethodDefinition < Node
    def infer(typer, expression)
      resolve_if(typer) do
        @defining_class ||= begin
          static_scope.self_node = :self
          static_scope.self_type = if static?
            scope.static_scope.self_type.meta
          else
            scope.static_scope.self_type
          end
        end
        @annotations.each {|a| a.infer(typer, true)} if @annotations
        typer.infer(arguments, true)
        if @return_type
          if @return_type.kind_of?(UnquotedValue)
            @return_type = @return_type.node
            @return_type.parent = self
          else
            @return_type.parent = self
          end
          signature[:return] = @return_type.type_reference(typer)
        end
        if @exceptions
          signature[:throws] = @exceptions.map {|e| e.type_reference(typer)}
        end
        typer.infer_signature(self)
        forced_type = signature[:return]
        body_is_expression = (forced_type != typer.no_type)
        inferred_type = body ? typer.infer(body, body_is_expression) : typer.no_type

        if inferred_type && arguments.inferred_type.all?
          actual_type = if forced_type.nil?
            inferred_type
          else
            forced_type
          end
          if actual_type.unreachable?
            actual_type = typer.no_type
          end

          if !abstract? &&
              forced_type != typer.no_type &&
              !actual_type.is_parent(inferred_type)
              #TODO figure out why this causes issues
            #raise Mirah::Typer::InferenceError.new(
            #    "Inferred return type %s is incompatible with declared %s" %
            #    [inferred_type, actual_type], self)
          end

          signature[:return] = actual_type
        end
      end
    end

  end
end

desc "run tests"
task :compile_test do #=> :jar do
  puts "Compiling Mirah tests"
  #args = Dir['*.{mirah,duby}']+[{#+ [{ :dir => 'test', :dest => 'test',
  #       :options => ['--classpath', '~/.m2/repository/junit/junit/4.8.2/junit-4.8.2.jar:~/.m2/repository/javax/servlet/servlet-api/2.5/servlet-api-2.5.jar']}]
  mirahc 'test_sinatra_clone.mirah',:options => [
      '--classpath', Dir['javalib/*.jar'].join(':')]#'/Users/nick/.m2/repository/junit/junit/4.8.2/junit-4.8.2.jar:~/.m2/repository/javax/servlet/servlet-api/2.5/servlet-api-2.5.jar']  
end


task :test => :compile_test do
  ant.junit :haltonfailure => 'true', :fork => 'true' do
    classpath :path => Dir['javalib/*.jar'].join(':')+':.'#(TESTING_JARS + ['build', 'test']).join(":")
    batchtest do
      fileset :dir => "." do
        include :name => '**/*Test.class'
      end
      formatter :type => 'plain', :usefile => 'false'
    end
  end
end
