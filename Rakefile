require 'ant'
require 'rubygems'
require 'bundler/setup'
require 'mirah_task'

desc "compiles library"
task :compile do
  puts "Compiling Mirah tests"
  mkdir_p 'build'
  mirahc 'shatner_base.mirah',:options => [ '--cd', 'src', '-d', '../build',
    '--classpath', Dir['javalib/*.jar'].join(':')]

end


task :compile_test => :compile do #=> :jar do
  puts "Compiling Mirah tests"
  mirahc *(Dir['test/test_*.mirah'] << {:options => [
    '--classpath', Dir['javalib/*.jar'].join(':') + ":build/"]})#,'-V']
end

desc "run tests"
task :test => :compile_test do
  ant.junit :haltonfailure => 'true', :fork => 'true' do
    classpath :path => Dir['javalib/*.jar'].join(':')+':build/:.'
    batchtest do
      fileset :dir => "test/" do
        include :name => '**/*Test.class'
      end
      formatter :type => 'plain', :usefile => 'false'
    end
  end
end
