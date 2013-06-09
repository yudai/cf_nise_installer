require "sinatra"
require "mysql2"
require "cf-autoconfig"

class HelloWorld < Sinatra::Base
  get "/" do
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    "Hello, World!"
  end
end
