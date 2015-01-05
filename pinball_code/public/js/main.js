Pinball = {
  switchPollingInterval: 1000,
  switchPollID: null,

  startup: function(){
    Pinball.reloadSwitches();
    $("a.reload_switches").click(function(event){
      event.preventDefault();
      Pinball.reloadSwitches(true);
    });
    $("select.polling-interval").change(function(){
      Pinball.switchPollingInterval = parseInt($("select.polling-interval").val());
      if(Pinball.switchPollingInterval != 0){
        Pinball.reloadSwitches(false);
        Pinball.setReloadSwitchesTimeout();
      }
    })
  },
  setReloadSwitchesTimeout: function(){
    if(Pinball.switchPollingInterval != 0){
      clearTimeout(Pinball.switchPollID);
      Pinball.switchPollID = setTimeout(function(){Pinball.reloadSwitches();}, Pinball.switchPollingInterval);
    }
  },
  reloadSwitches: function(preventReload){
    $.get("/switch_data", function(data){
      $.each(data, function(idx, d){
        element = $("td.switch.r"+d.r+"c"+d.c)
        element.html(d.ip);
        if(d.ip == 0){
          element.removeClass("switch-on");
          element.addClass("switch-off");
        }else{
          element.removeClass("switch-off");
          element.addClass("switch-on");
        }
      });
      if(preventReload != true){
        Pinball.setReloadSwitchesTimeout();
      }
    });
  }
}