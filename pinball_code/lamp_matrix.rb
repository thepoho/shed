require 'pi_piper'
include PiPiper

#example code for testing a WPC11 switch matrix using a raspberry PI and poho's super switch matrix PCB

column_pin_numbers = [2,3,4]
row_pin_numbers = [17,27,22]

column_pins = column_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}
row_pins  = row_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}

    row_pins.each {|x| x.on}
    column_pins.each {|x| x.on}
exit
while true
  data = []
  column_pins.each do |col|

    column_pins.each {|x| x.off}

    col.on 
    #at this stage our column is set, now to read the rows

  end
end
