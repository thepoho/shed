## Lamp Class ##
#Valid states are :on, :off, :flash_slow, :flash_fast

class Switch
  @@switches = []
  @@indexed_switches = {}

  attr_accessor :id, :name, :col, :row, :was_pressed, :is_pressed
  def initialize(opts)
    #@options = {}
    %w{name col row}.each do |x|
      instance_variable_set("@#{x}", opts[x.to_sym])
    end
    @was_pressed = @is_pressed = false
    @@switches << self
    @@indexed_switches["#{@col}_#{@row}"] = self
    self #unnecessary
  end

  def down
    @is_pressed = true
  end

  def up
    if @is_pressed
      @was_pressed = true
    end
    @is_pressed = false
  end


  def self.find_by_location(col, row)
    @@indexed_switches["#{col}_#{row}"]
  end

  def self.all
    @@ret ||= @@indexed_switches.map{|k,v| v}
  end

end
