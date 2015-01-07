## Lamp Class ##
#Valid states are :on, :off, :flash_slow, :flash_fast

class Lamp
  attr_accessor :id, :name, :col, :row, :xpos, :ypos, :state, :r, :g, :b, :value

  FAST_FLASH_SPEED = 200
  SLOW_FLASH_SPEED = 600

  @@sorted_lamps_by_column = {}
  @@lamps = []

  @@fast_flash = @@slow_flash = false
  @@last_fast_flash = @@last_slow_flash = 0
  @@elapsed_time = 0

  def initialize(opts)
    #@options = {}
    %w{name col row xpos ypos}.each do |x|
      instance_variable_set("@#{x}", opts[x.to_sym])
    end
    @r = @g = @b = 255
    
    # @state = rand(2) == 0 ? :flash_fast : :flash_slow
    @state = :flash_fast
    @value = 0
    @@lamps << self
    @@sorted_lamps_by_column[@col] ||= []
    @@sorted_lamps_by_column[@col] << self
    @@sorted_lamps_by_column[@col].sort!{|x,y| x.col <=> y.col}
    self
  end

  def lit?
    @value == 1
  end

  def on?
    @state == :on
  end
  def off?
    @state == :off
  end
  def fast_flash?
    @state == :flash_fast
  end
  def slow_flash?
    @state == :flash_slow
  end

  def self.find_by_location(col, row)
    # @@sorted_lamps_by_column[col][row]
    self.lamps_for_column(col)[row.to_i]
  end

  def self.lamps_for_column(col)
    @@sorted_lamps_by_column[col.to_i] || []
  end
  def self.all
    @@lamps
    #@@ret ||= @@sorted_lamps_by_column.map{|k,v| v}.flatten
  end
  def self.update(delta)
    @@elapsed_time += delta
    # @@last_time = @@elapsed_time
    #work out if fast_flash needs switching state
    if @@elapsed_time >= (@@last_fast_flash + FAST_FLASH_SPEED)
      @@last_fast_flash = @@elapsed_time
      @@fast_flash = !@@fast_flash
      # @@fast_flash = @@fast_flash ? 1 : 0 
    end

    #work out if slow_flash needs switching state
    if @@elapsed_time >= (@@last_slow_flash + SLOW_FLASH_SPEED)
      @@last_slow_flash = @@elapsed_time
      @@slow_flash = !@@slow_flash
      # @@slow_flash = @@slow_flash ? 1 : 0
    end

    # puts @@fast_flash

    @@lamps.each_with_index do |lamp,idx|
      if lamp.slow_flash?
        lamp.value = @@slow_flash ? 1 : 0
      end

      if lamp.fast_flash?
        lamp.value = @@fast_flash ? 1 : 0
      end

      lamp.value = 0 if lamp.off?
      lamp.value = 1 if lamp.on?
      # if idx == 0
#        puts lamp.value
      # end
    end
  end
end
