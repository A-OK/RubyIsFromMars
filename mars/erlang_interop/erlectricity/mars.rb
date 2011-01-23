require 'erlectricity'

receive do |receiver|
  receiver.when([:mars_age, Fixnum]) do |age|
    receiver.send!([:result, age/(686.98/65.26)])
    receiver.receive_loop
  end
end