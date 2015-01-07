Pinball.Lamps = {
  lampPollingInterval: 1000,
  lampPollID: null,

  startup: function(){
    Pinball.Lamps.reloadLamps();
    $("a.reload_lamps").click(function(event){
      event.preventDefault();
      Pinball.Lamps.reloadLamps(true);
    });
    $("select.lamp-polling-interval").change(function(){
      Pinball.Lamps.lampPollingInterval = parseInt($("select.lamp-polling-interval").val());
      if(Pinball.Lamps.lampPollingInterval == 0){
        clearTimeout(Pinball.Lamps.lampPollID);
      }else{
        Pinball.Lamps.reloadLamps(false);
        Pinball.Lamps.setReloadLampsTimeout();
      }
    });
    $("td.lamp").click(function(){
      var val = $(this).find("span.display").html();
      var next;
      if(val == "FF")
        next = "SF";
      if(val == "SF")
        next = "OFF";
      if(val == "OFF")
        next = "ON";
      if(val == "ON")
        next = "FF";

      var col = $(this).attr("data-col");
      var row = $(this).attr("data-row");
     
      var to_send = {row: row, col: col, state: next};
      $.post("/set_lamp", to_send, function(data){
        $(this).find("span.display").html(next);
      });
    });
    #$("td.lamp").popover({html: true, 
    #  content: function(){
    #  return($(this).find(".lamp_details").html());
    #}});
  },
  setReloadLampsTimeout: function(){
    if(Pinball.Lamps.lampPollingInterval != 0){
      clearTimeout(Pinball.Lamps.lampPollID);
      Pinball.Lamps.lampPollID = setTimeout(function(){Pinball.Lamps.reloadLamps();}, Pinball.Lamps.lampPollingInterval);
    }
  },
  reloadLamps: function(preventReload){
    $.get("/lamp_data", function(data){
      $.each(data, function(idx, d){
        element = $("td.lamp.r"+d.r+"c"+d.c);
        var tmp = {flash_fast: "FF", flash_slow: "FS", on: "ON", off: "OFF"}
        element.find("span.display").html(tmp[d.s]);
        if(d.l == 0){
          element.removeClass("lamp-on");
          element.addClass("lamp-off");
        }else{
          element.removeClass("lamp-off");
          element.addClass("lamp-on");
        }
      });
      if(preventReload != true){
        Pinball.Lamps.setReloadLampsTimeout();
      }
    });
  }
}
