class LampController
  require 'yaml'
  require './lamp.rb'
  if Gem::Platform.local.cpu == "arm"
    require 'pi_piper'
  else
    require './poho_pi_piper_emulator.rb'
  end


  attr_accessor :lamps
  DATA_FILE = "lamp_data.yml"

  def initialize
    lamp_data = YAML::load(File.open(DATA_FILE)) rescue {}

    @lamps = []
    lamp_data[:lamps].each do |x|
      @lamps << Lamp.new(x)
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
  
  def start_thread
    @@thread = Thread.new do
      while true
        (0..7).each do |col|

          @row_pins.each{|r| r.off}

          #TODO: pre-generate these arrays
          output_arr = ("%b" % col).split(//).map(&:to_i)
          output_arr = [0] + output_arr while output_arr.length < 3
          output_arr.each_with_index do |num, idx|
            if num == 0
              @column_pins[idx].on
            else
              @column_pins[idx].off
            end
          end
          #at this stage our column is set, now to set the rows
          @col_lamps[col].each do |lamp|
            if lamp.state == 1
              @row_pins[lamp.row].on
            else
              @row_pins[lamp.row].off
            end
          end if @col_lamps[col]
          sleep(0.01)
        end
      end
    end
  end

  def thread
    @@thread
  end
  
  
end
