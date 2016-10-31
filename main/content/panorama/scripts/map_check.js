"use strict";

 function OnMapCheck( event_data )
 {
	var parentPanel = $.GetContextPanel(); // the root panel of the current XML context
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "Hud" );
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/hud_hero_demo.xml", true, false );
 }
 
 GameEvents.Subscribe( "map_check", OnMapCheck );