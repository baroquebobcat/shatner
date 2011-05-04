require 'ant'
require 'rubygems'
require 'mirah_task'

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
