require "erlix"

ErlixNode.init("client_node","venus")
connection=ErlixConnection.new("venus_server@localhost")
connection.esend("venus_server",ErlixTuple.new([ErlixPid.new(connection),
                                                  ErlixInt.new(17)]))

t=Thread.start("thread recv"){ |name|
  while true do
    m=connection.erecv
    puts m.message
  end
}
t.join

