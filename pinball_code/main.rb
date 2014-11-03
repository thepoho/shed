if Gem::Platform.local.cpu == "arm"
  require 'pi_piper'
else
  require './poho_pi_emulator.rb'
end