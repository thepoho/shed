  if Gem::Platform.local.cpu == "arm"
    require 'pi_piper'
  else
    require './poho_pi_piper_emulator.rb'
  end


    column_pin_numbers = [2,3]
    row_pin_numbers = [17,27]
    
 
    @column_pins = column_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}
    @row_pins    = row_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}

    @column_pins.each {|x| x.on}
    @row_pins.each {|x| x.on}


    while true
  
      #now work the matrix, baby
      (0..7).each do |col|
        @column_pins.each do |col|

        #turn off all the rows to prevent ghosting
        @row_pins.each{|r| r.off}

        @column_pins.each{|c| c.off}

        col.on
        #set the columns
        #output_data[col].each_with_index do |num, idx|
        #  if num == 0
        #    @column_pins[idx].on
        #  else
        #    @column_pins[idx].off
        #  end
        #end

        #at this stage our column is set, now to set the rows
        #Lamp.lamps_for_column(0).each do |lamp|
        lamp = Lamp.lamps.first
          if lamp.value == 1
            @row_pins[lamp.row].on
          else
            @row_pins[lamp.row].off
          end
        #end
       
        #at this point our required lights should be on

        #now avoid thrashing the CPU and maybe let the light stay on for a tiny bit of time
        sleep(0.001)

      end
    end
