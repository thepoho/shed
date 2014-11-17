## Lamp Class ##
#Valid states are :on, :off, :flash_slow, :flash_fast

class Lamp
  attr_accessor :id, :name, :col, :row, :xpos, :ypos, :state, :r, :g, :b, :value

  FAST_FLASH_SPEED = 100
  SLOW_FLASH_SPEED = 500

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
    @state = :flash_fast
    @value = 0
    @@lamps << self
    @@sorted_lamps_by_column[@col] ||= []
    @@sorted_lamps_by_column[@col] << self
    @@sorted_lamps_by_column[@col].sort!{|x,y| x.col <=> y.col}
    self
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

  def self.lamps_for_column(col)
    @@sorted_lamps_by_column[col] || []
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
    end

    #work out if slow_flash needs switching state
    if @@elapsed_time >= (@@last_slow_flash + SLOW_FLASH_SPEED)
      @@last_slow_flash = @@elapsed_time
      @@slow_flash = !@@slow_flash
    end

    @@lamps.each do |lamp|
      lamp.value = @@slow_flash if lamp.slow_flash?
      lamp.value = @@fast_flash if lamp.fast_flash?
      lamp.value = 0 if lamp.off?
      lamp.value = 1 if lamp.on?
    end
  end
end
