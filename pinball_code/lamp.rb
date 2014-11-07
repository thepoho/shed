## Lamp Class ##
#Valid states are :on, :off, :flash_slow, :flash_fast

class Lamp
  attr_accessor :id, :name, :col, :row, :xpos, :ypos, :state, :r, :g, :b
  def initialize(opts)
    #@options = {}
    %w{name col row xpos ypos}.each do |x|
      instance_variable_set("@#{x}", opts[x.to_sym])
    end
    @r = @g = @b = 255
    @state = :off
    
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
end
