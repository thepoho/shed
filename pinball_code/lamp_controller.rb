class LampController
  require 'yaml'
  require './lamp.rb'
  if Gem::Platform.local.cpu == "arm"
    require 'pi_piper'
  else
    require './poho_pi_piper_emulator.rb'
  end

  DATA_FILE = "lamp_data.yml"
  FAST_FLASH_SPEED = 100
  SLOW_FLASH_SPEED = 500

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

    @row_pins.each {|x| x.off}
    @column_pins.each {|x| x.off}
  end

  def lamp(identifier)
    @lamps_by_name[identifier]
  end
  
  def start_thread
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

    #set up some variables so we know if we are flashing or not
    last_time = Time.now.to_f * 1000
    elapsed_time = 0
    fast_flash = slow_flash = false
    last_fast_flash = last_slow_flash = 0

    while true
      #work out our current delta
      new_time = Time.now.to_f * 1000
      elapsed_time += (new_time - last_time)
      last_time = new_time

      #work out if fast_flash needs switching state
      if elapsed_time >= (last_fast_flash + FAST_FLASH_SPEED)
        last_fast_flash = elapsed_time
        fast_flash = !fast_flash
      end

      #work out if slow_flash needs switching state
      if elapsed_time >= (last_slow_flash + SLOW_FLASH_SPEED)
        last_slow_flash = elapsed_time
        slow_flash = !slow_flash
      end

      #now work the matrix, baby
      (0..7).each do |col|

        #turn off all the rows to prevent ghosting
        @row_pins.each{|r| r.off}

        #set the columns
        output_data[col].each_with_index do |num, idx|
          if num == 0
            @column_pins[idx].on
          else
            @column_pins[idx].off
          end
        end

        #at this stage our column is set, now to set the rows
        Lamp.lamps_for_column(col).each do |lamp|
          if lamp.on? || (lamp.fast_flash? && fast_flash) || (lamp.slow_flash? && slow_flash)
            @row_pins[lamp.row].on
          else
            @row_pins[lamp.row].off
          end
        end
       
        #at this point our required lights should be on

        #now avoid thrashing the CPU and maybe let the light stay on for a tiny bit of time
        sleep(0.01)

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
