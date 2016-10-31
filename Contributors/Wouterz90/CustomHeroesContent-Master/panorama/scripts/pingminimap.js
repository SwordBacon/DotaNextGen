"use strict";
function PingMinimapAtLocation( msg )
{
  GameUI.PingMinimapAtLocation( msg.pos );        

}

function GetMousePosition(msg)
{
  var position = GameUI.GetCursorPosition();
  var world_position = GameUI.GetScreenWorldPosition(position);
  
  var player = msg.hPlayer;
  //$.Msg(world_position);
  GameEvents.SendCustomGameEventToServer("MousePosition", {player:player, world_position:world_position});
}

(function () {
    GameEvents.Subscribe( "ping_minimap", PingMinimapAtLocation );
    GameEvents.Subscribe("GetCurrentMouseLocation", GetMousePosition);
})();