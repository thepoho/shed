## Lamp Class ##
#Valid states are :on, :off, :flash_slow, :flash_fast

class Lamp
  attr_accessor :id, :name, :col, :row, :xpos, :ypos, :state, :r, :g, :b
  @@sorted_lamps_by_column = {}
  
  def initialize(opts)
    #@options = {}
    %w{name col row xpos ypos}.each do |x|
      instance_variable_set("@#{x}", opts[x.to_sym])
    end
    @r = @g = @b = 255
    @state = :flash_fast
    # @@lamps << self
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
    @@ret ||= @@sorted_lamps_by_column.map{|k,v| v}.flatten
  end
end
