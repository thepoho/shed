if Gem::Platform.local.cpu == "arm"
  require 'pi_piper'
else
  require './poho_pi_piper_emulator.rb'
end

require './switch_controller.rb'

sc = SwitchController.new
sc.run(true)
