if Gem::Platform.local.cpu == "arm"
  require 'pi_piper'
else
  require './poho_pi_piper_emulator.rb'
end

require './lamp_controller.rb'
require './switch_controller.rb'

DEBUG_LAMPS     = true
DEBUG_SWITCHES  = false

lc = LampController.new
sc = SwitchController.new

lc.start_thread
sc.start_thread

last_run = Time.now.to_f * 1000

while(true)
  now = (Time.now.to_f * 1000)
  delta = now - last_run
  last_run = now

  Lamp.update(delta)

  #No such thing as a switch update... yes
  # Switch.update(delta)


  if DEBUG_LAMPS
    lamps = []
    (0..7).each do |col|
      lamps << Lamp.lamps_for_column(col).map{|x| x.lit? ? 1 : 0}.join("")
    end
    print lamps.join(" ")
    # print "\n poho"
    #print lamps.join(" ")
    72.times do |x|
      print "\b"
    end
    
  end
   
  if DEBUG_SWITCHES
    switches = []
    Switch.all.each_with_index do |switch, idx|
      switches << " " if idx != 0 && idx % 8 == 0
      switches << (switch.is_pressed ? 1 : 0)
    end
    print switches.join("")

    72.times do |x|
      print "\b"
    end
    
  end
end
