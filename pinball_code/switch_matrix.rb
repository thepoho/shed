require 'pi_piper'
include PiPiper

#example code for testing a WPC11 switch matrix using a raspberry PI and poho's super switch matrix PCB

output_pin_numbers = [14,15,18]
input_pin_numbers = [23, 24, 25, 8, 7, 12, 16, 20]

output_pins = output_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}
input_pins  = input_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :in)} #pull: :up

while true
  data = []
  (0..7).each do |col|
    output_arr = ("%b" % col).split(//).map(&:to_i)
    output_arr = [0] + output_arr while output_arr.length < 3
#    puts output_arr.inspect
    output_arr.each_with_index do |num, idx|
      if num == 0
        output_pins[idx].on
      else
        output_pins[idx].off
      end
    end
    #at this stage our column is set, now to read the rows

    tmp = []
    input_pins.each do |row|
      tmp << row.read
    end
    data << tmp
    data << ' '
  end
  print data.join + "\r"
end
