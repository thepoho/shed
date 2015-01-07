  if Gem::Platform.local.cpu == "arm"
    require 'pi_piper'
  else
    require './poho_pi_piper_emulator.rb'
  end


    #column_pin_numbers = [8,9,7]
    #column_pin_numbers = [3,5,7]
    column_pin_numbers = [2,3,4]
    #row_pin_numbers = [0,2,3,12,13,14,21,22]
    #row_pin_numbers = [11,13,15,19,21,23,29,31]
    row_pin_numbers = [17,27,22,10,9,11,5,6]
    

    col_bin = [[0,0,0],[1,0,0],[0,1,0],[1,1,0],[0,0,1],[1,0,1],[0,1,1],[1,1,1]]
    
 
    @column_pins = column_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}
    @row_pins    = row_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}

    @column_pins.each {|x| x.on}
    @row_pins.each {|x| x.on}


    while true
  
      #now work the matrix, baby
      (0..7).each do |col|
        #turn off all the rows to prevent ghosting
        @row_pins.each{|r| r.off}

        @column_pins.each{|c| c.off}

        bin = col_bin[col]
        (0..2).each do |x|
          if bin[x] == 0
            @column_pins[x].off
          else
            @column_pins[x].on
          end
        end
        
        #at this stage our column is set, now to set the rows
        @row_pins.each do |r|
          r.on
        end
       
        #at this point our required lights should be on

        #now avoid thrashing the CPU and maybe let the light stay on for a tiny bit of time
        sleep(0.111)

      end
    #end
end
