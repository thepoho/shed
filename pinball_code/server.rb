class Server
  def self.lamps
    lamps = []
    (0..7).each do |col|
      lamps << Lamp.lamps_for_column(col).map{|x| x.lit? ? 1 : 0}.join("")
    end
    lamps.join(" ")
  end
end