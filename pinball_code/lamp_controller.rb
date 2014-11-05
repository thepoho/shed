class LampController
  attr_accessor :lamps
  column_pin_numbers = [2,3,4]
  row_pin_numbers = [17,27,22,10,9,11,5,6] #pin 21??

  def initialize(lamps)
    @lamps = lamps

    @col_lamps = {}
    lamps.each do |l|
      @col_lamps[l.col] ||= []
      @col_lamps[l.col] << l
#      @col_lamps[l.col].sort!
    end

    @row_lamps = {}
    lamps.each do |l|
      @row_lamps[l.row] ||= []
      @row_lamps[l.row] << l
#      @row_lamps[l.row].sort!
    end

    @column_pins = column_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}
    @row_pins    = row_pin_numbers.map{|x| PiPiper::Pin.new(pin: x, direction: :out)}

    @row_pins.each {|x| x.off}
    @column_pins.each {|x| x.off}
  end

  def start_thread
    @@thread = Thread.new do
      while true
        (0..7).each do |col|
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
          end
        end
      end
    end
  end
  def thread
    @@thread
  end
end
