require 'erlang'

Erlang::client("venus_client@localhost", "venus") do |client|
  venus_server = Erlang::OtpPeer.new("venus_server@localhost")

  connection = client.connect(venus_server)

  connection.send("venus_server", Erlang::tuple(client.pid,
                                  Erlang::num(17)))
  venus_age = connection.receive
  puts venus_age.doubleValue
end
