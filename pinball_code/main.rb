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

DEBUG           = true
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


      # if (DEBUG_LAMPS || DEBUG_SWITCHES) && Time.now.to_f > (last_debug + 0.5)
      #   #only show a debug every .1 seconds
      #   last_debug = Time.now.to_f
      #   if DEBUG_LAMPS
      #     71.times do |x|
      #       print "\b"
      #     end
      #     lamps = []
      #     (0..7).each do |col|
      #       lamps << Lamp.lamps_for_column(col).map{|x| x.lit? ? 1 : 0}.join("")
      #     end
      #     print lamps.join(" ")
      #     # print "\n poho"
      #     #print lamps.join(" ")
    
      #   end
   
      #   if DEBUG_SWITCHES
      #     switches = []
      #     Switch.all.each_with_index do |switch, idx|
      #       switches << " " if idx != 0 && idx % 8 == 0
      #       switches << (switch.is_pressed ? 1 : 0)
      #     end
      #     print switches.join("")
  
      #     72.times do |x|
      #       print "\b"
      #     end
      #   end
      # end  
      # yield
      sleep(0.0001)
    end
  end
end

main = Main.new
#Server.new(main)
unless DEBUG
  Thread.new do
    main.run
    #sleep(0.001)
    # sleep(0.0001)
    # yield
  end
end

Thread.new do 
  get '/' do
    haml :index
    # "poho"
  end
  get '/lamp_data' do
    content_type :json
    Lamp.all.map{|x| {r: x.row, c: x.col, s: x.state, l: x.lit?}}.to_json
  end
  get '/switch_data' do
    content_type :json
    Switch.all.map{|x| {r: x.row, c: x.col, ip: x.is_pressed ? 1 : 0, wp: x.was_pressed ? 1 : 0}}.to_json
    # Switch.all.map{|x| {r: x.row, c: x.col, ip: rand(2), wp: x.was_pressed ? 1 : 0}}.to_json
  end
  # sleep(0.0001)
end

# include 'server.rb'