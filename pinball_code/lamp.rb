class Lamp
  attr_accessor :id, :name, :col, :row, :xpos, :ypos, :state, :r, :g, :b
  def initialize(opts)
    @options = {}
    %w{name col row xpos ypos}.each do |x|
      @options[x.to_sym] = opts[x.to_sym]
    end
    @options[:r] = @options[:g] = @options[:b] = 255
    @options[:state] = 0
    
  end
end
