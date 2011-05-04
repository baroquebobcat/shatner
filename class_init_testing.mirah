import java.util.HashMap
class Foo
  def self.initialize
    @routes = HashMap.new
  end
  def self.routes
    puts @routes
  end
end

class Bar < Foo
  def self.initialize
    @routes.put "1", "2"
  end
def self.routes
puts @routes
end
end

puts Foo.routes
puts Bar.routes