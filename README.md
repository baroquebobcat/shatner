Shatner
===========================
Shatner is a super awesome double alpha version clone of Sinatra in Mirah.

It only supports get right now and you can only give it exact routes.

Also, your blocks have to return strings.

With those caveats, behold

    class HelloWorld < ShatnerBase
      get '/' do
        "hello, ... world."
      end
    end
