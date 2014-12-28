class LampController
  require 'yaml'
  require './lamp.rb'
  if Gem::Platform.local.cpu == "arm"
    require 'pi_piper'
  else
    require './poho_pi_piper_emulator.rb'
  end

  DATA_FILE = "lamp_data.yml"

  def initialize
    lamp_data = YAML::load(File.open(DATA_FILE)) rescue {}

    @lamps_by_name = {}
    lamp_data[:lamps].each do |x|
      Lamp.new(x)
    end


    column_pin_numbers = lamp_data[:col_pins]
    row_pin_numbers    = lamp_data[:row_pins]
    
 
    @column_pins = column_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}
    @row_pins    = row_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}

    @row_pins.each {|x| x.on}
    @column_pins.each {|x| x.on}
  end

  def lamp(identifier)
    @lamps_by_name[identifier]
  end
  
  def start_thread
    #return 0
    @@thread = Thread.new do
      self.run
    end
  end

  def run
    #pre-generate the binary arrays for the column encoder
    output_data = (0..7).map do |x|
      ret = ("%b" % x).split(//).map(&:to_i)
      ret = [0] + ret while ret.length < 3
      ret
    end

    while true
  
      #now work the matrix, baby
      (0..7).each do |col|
        
        #turn off all columns
        @column_pins.each {|x| x.off}

        #set the rows appropriately
        Lamp.lamps_for_column(col).each do |lamp|
          lamp = Lamp.lamps.first
          if lamp.lit?
            @row_pins[lamp.row].on
          else
            @row_pins[lamp.row].off
          end
        end

        #now do the columns, setting the lights on!
        output_data[col].each_with_index do |num, idx|
         if num == 0
           @column_pins[idx].on
         else
           @column_pins[idx].off
         end
        end
       
        #at this point our required lights should be on

        #now avoid thrashing the CPU and maybe let the light stay on for a tiny bit of time
        sleep(0.001)

      end
    end
  end

  def thread
    @@thread
  end

  def lamps
    Lamp.all
  end

end
