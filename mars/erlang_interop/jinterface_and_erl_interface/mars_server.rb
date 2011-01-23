require 'erlang'

Erlang::server("mars_server@localhost", "mars") do |server, connection|
  while true
    message=connection.receive
    caller_pid = message.element_at(0)
    age = message.element_at(1)
    connection.send(caller_pid, Erlang::double(age.double_value/(686.98/365.26)))
  end
end
