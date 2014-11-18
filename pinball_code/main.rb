if Gem::Platform.local.cpu == "arm"
  require 'pi_piper'
else
  require './poho_pi_piper_emulator.rb'
end

require './lamp_controller.rb'
require './switch_controller.rb'

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
end
