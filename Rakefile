require 'ant'
require 'rubygems'
require 'bundler/setup'
require 'mirah_task'

desc "run tests"
task :compile_test do #=> :jar do
  puts "Compiling Mirah tests"
  mirahc 'test_sinatra_clone.mirah',:options => [
    '--classpath', Dir['javalib/*.jar'].join(':')]
end


task :test => :compile_test do
  ant.junit :haltonfailure => 'true', :fork => 'true' do
    classpath :path => Dir['javalib/*.jar'].join(':')+':.'
    batchtest do
      fileset :dir => "." do
        include :name => '**/*Test.class'
      end
      formatter :type => 'plain', :usefile => 'false'
    end
  end
end
