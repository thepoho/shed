class SwitchController
  require 'yaml'
  require './switch.rb'
  if Gem::Platform.local.cpu == "arm"
    require 'pi_piper'
  else
    require './poho_pi_piper_emulator.rb'
  end

  DATA_FILE = "switch_data.yml"

  attr_accessor :switches

  def initialize
    switch_data = YAML::load(File.open(DATA_FILE)) rescue {}

    switch_data[:switches].each do |x|
      Switch.new(x)
    end

    puts switch_data[:switches].count

    output_pin_numbers = switch_data[:output_pins]
    input_pin_numbers  = switch_data[:input_pins]
 
    @output_pins = output_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}
    @input_pins  = input_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :in)}

    @output_pins.each {|x| x.off}
  end
  
  #TODO - all below here
  def start_thread #does this need to be its own thread?
    @@thread = Thread.new do
      self.run
    end
  end

  def thread
    @@thread
  end

  def run(debug=false)
    #pre-generate the binary arrays for the column encoder
    output_data = (0..7).map do |x|
      ret = ("%b" % x).split(//).map(&:to_i)
      ret = [0] + ret while ret.length < 3
      ret
    end

    while true
      (0..7).each do |col|
        #set the column
        output_data[col].each_with_index do |num, idx|
          if num == 0
            @output_pins[idx].on
          else
            @output_pins[idx].off
          end 
        end
        #at this stage our column is set, now to set the rows
        @input_pins.each_with_index do |row,idx|
          tmp = row.read
          if switch = Switch.find_by_location(col, idx)
          
            if tmp == 0
              switch.up #no problem continually calling up if state hasnt changed
            else
              switch.down
            end
          end
        end
         
        #now avoid thrashing the CPU
        sleep(0.01)
      end
      
    end #ends the while true loop


  end

end
