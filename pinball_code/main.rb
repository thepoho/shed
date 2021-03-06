if Gem::Platform.local.cpu == "arm"
  require 'pi_piper'
else
  require './poho_pi_piper_emulator.rb'
end

require './lamp_controller.rb'
require './switch_controller.rb'
require 'sinatra'
require 'json'

require './server.rb'

DEBUG           = false
DEBUG_LAMPS     = false
DEBUG_SWITCHES  = false

class Main

  attr_accessor :lc, :sc
  def initialize
    @lc = LampController.new
    @sc = SwitchController.new
  end

  def run
    @lc.start_thread
    @sc.start_thread

    last_debug = Time.now.to_f

    last_run = Time.now.to_f * 1000

    while(true)
      now = (Time.now.to_f * 1000)
      delta = now - last_run
      last_run = now

      Lamp.update(delta)

      #No such thing as a switch update... yes
      # Switch.update(delta)


      sleep(0.01)
    end
  end
end

main = Main.new
@lc = LampController.new
@lc.run
#Thread.new do
#  main.run
#end

if false
  Thread.new do 
    get '/' do
      haml :index
      # "poho"
    end
    get '/lamp_data' do
      content_type :json
      #value - same as lit? method
      Lamp.all.map{|x| {r: x.row, c: x.col, s: x.state, l: x.value}}.to_json
      # Lamp.all.map{|x| {r: x.row, c: x.col, s: x.state, l: rand(2)}}.to_json
    end
    get '/switch_data' do
      content_type :json
      # Switch.all.map{|x| {r: x.row, c: x.col, ip: x.is_pressed ? 1 : 0, wp: x.was_pressed ? 1 : 0}}.to_json
      Switch.all.map{|x| {r: x.row, c: x.col, ip: rand(2), wp: x.was_pressed ? 1 : 0}}.to_json
    end
    post '/set_lamp' do
      if l = Lamp.find_by_location(params[:col], params[:row])
        lookups = {"ON" => :on, "OFF" => :off, "FF" => :fast_flash, "FS" => :flash_slow}
        tmp = lookups[params[:state]]
        # unless tmp.blank?
          l.state = tmp
        # end
      end
      Lamp.all.map{|x| {r: x.row, c: x.col, s: x.state, l: x.value}}.to_json
    end
  end
end
