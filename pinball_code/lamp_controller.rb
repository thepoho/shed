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

  attr_accessor :lamps

  def initialize
    lamp_data = YAML::load(File.open(DATA_FILE)) rescue {}

    @lamps = []
    @lamps_by_name = {}
    lamp_data[:lamps].each do |x|
      tmp = Lamp.new(x)
      @lamps << tmp
      @lamps_by_name[x[:name]] = tmp
    end

    @col_lamps = {}
    @lamps.each do |l|
      @col_lamps[l.col] ||= []
      @col_lamps[l.col] << l
#      @col_lamps[l.col].sort!
    end

    @row_lamps = {}
    @lamps.each do |l|
      @row_lamps[l.row] ||= []
      @row_lamps[l.row] << l
#      @row_lamps[l.row].sort!
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

      #pre-generate the binary arrays for the column encoder
      output_data = (0..7).map do |x|
        ret = ("%b" % x).split(//).map(&:to_i)
        ret = [0] + ret while ret.length < 3
        ret
      end

      last_time = Time.now.to_f * 1000
      elapsed_time = 0
      fast_flash = slow_flash = false
      last_fast_flash = last_slow_flash = 0

      while true
        new_time = Time.now.to_f * 1000
        elapsed_time += (new_time - last_time)
        last_time = new_time

        if elapsed_time >= (last_fast_flash + FAST_FLASH_SPEED)
          last_fast_flash = elapsed_time
          fast_flash = !fast_flash
        end

        if elapsed_time >= (last_slow_flash + SLOW_FLASH_SPEED)
          last_slow_flash = elapsed_time
          slow_flash = !slow_flash
        end

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
          @col_lamps[col].each do |lamp|
            if lamp.on? || (lamp.fast_flash? && fast_flash) || (lamp.slow_flash? && slow_flash)
              @row_pins[lamp.row].on
            else
              @row_pins[lamp.row].off
            end
          end if @col_lamps[col]
         
          #at this point ourrequired lights should be on

	  #now avoid thrashing the CPU
          sleep(0.01)

        end
      end
    end
  end

  def thread
    @@thread
  end

end
