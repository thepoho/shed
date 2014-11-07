class Lamp
  attr_accessor :id, :name, :col, :row, :xpos, :ypos, :state, :r, :g, :b
  def initialize(opts)
    #@options = {}
    %w{name col row xpos ypos}.each do |x|
      instance_variable_set("@#{x}", opts[x.to_sym])
    end
    @r = @g = @b = 255
    @state = 0
    
  end
end
