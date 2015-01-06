Pinball.Switches = {
  switchPollingInterval: 1000,
  switchPollID: null,

  startup: function(){
    Pinball.Switches.reloadSwitches();
    $("a.reload_switches").click(function(event){
      event.preventDefault();
      Pinball.Switches.reloadSwitches(true);
    });
    $("select.switch-polling-interval").change(function(){
      Pinball.Switches.switchPollingInterval = parseInt($("select.switch-polling-interval").val());
      if(Pinball.Switches.switchPollingInterval == 0){
        clearTimeout(Pinball.Switches.switchPollID);
      }else{
        Pinball.Switches.reloadSwitches(false);
        Pinball.Switches.setReloadSwitchesTimeout();
      }
    });
    $("td.switch").popover({html: true, 
      content: function(){
      return($(this).find(".switch_details").html());
    }});
  },
  setReloadSwitchesTimeout: function(){
    if(Pinball.Switches.switchPollingInterval != 0){
      clearTimeout(Pinball.Switches.switchPollID);
      Pinball.Switches.switchPollID = setTimeout(function(){Pinball.Switches.reloadSwitches();}, Pinball.Switches.switchPollingInterval);
    }
  },
  reloadSwitches: function(preventReload){
    $.get("/switch_data", function(data){
      $.each(data, function(idx, d){
        element = $("td.switch.r"+d.r+"c"+d.c);
        element.find("span.display").html(d.ip);
        if(d.ip == 0){
          element.removeClass("switch-on");
          element.addClass("switch-off");
        }else{
          element.removeClass("switch-off");
          element.addClass("switch-on");
        }
      });
      if(preventReload != true){
        Pinball.Switches.setReloadSwitchesTimeout();
      }
    });
  }
}