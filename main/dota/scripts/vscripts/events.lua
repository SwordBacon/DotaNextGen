--[[ Events ]]

--------------------------------------------------------------------------------
-- GameEvent:OnGameRulesStateChange
--------------------------------------------------------------------------------
function GameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print( "OnGameRulesStateChange: Hero Selection" )

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		print( "OnGameRulesStateChange: Pre Game Selection" )
		SendToServerConsole( "dota_dev forcegamestart" )

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print( "OnGameRulesStateChange: Game In Progress" )
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCSpawned
--------------------------------------------------------------------------------
function GameMode:OnNPCSpawned( event )
	spawnedUnit = EntIndexToHScript( event.entindex )
	 -- This internal handling is used to set up main barebones functions
  	GameMode:_OnNPCSpawned(event)
  	local npc = EntIndexToHScript(event.entindex)

	if spawnedUnit:GetPlayerOwnerID() == 0 and spawnedUnit:IsRealHero() and not spawnedUnit:IsClone() then
		--print( "spawnedUnit is player's hero" )
		local hPlayerHero = spawnedUnit
		
		hPlayerHero:SetContextThink( "self:Think_InitializePlayerHero", function() return self:Think_InitializePlayerHero( hPlayerHero ) end, 0 )
	end

	if spawnedUnit:GetUnitName() == "npc_dota_neutral_caster" then
		--print( "Neutral Caster spawned" )
		spawnedUnit:SetContextThink( "self:Think_InitializeNeutralCaster", function() return self:Think_InitializeNeutralCaster( spawnedUnit ) end, 0 )
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnAbilityUsed
--------------------------------------------------------------------------------
function GameMode:OnAbilityUsed( event )
	local ply = EntIndexToHScript( event.PlayerID )
	if ply then
		local hero = PlayerResource:GetSelectedHeroEntity( event.PlayerID )
		if hero then 
			local ability = event.abilityname
			for i = 0, hero:GetAbilityCount() do 
				if hero:FindAbilityByName(ability) then
					hero.lastAbility = ability
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Event: OnItemPickUp
--------------------------------------------------------------------------------
--[[function GameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	--r = RandomInt(200, 400)
	if event.itemname == "item_bag_of_gold" then
		--print("Bag of gold picked up")
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end
]]--
--------------------------------------------------------------------------------
-- Think_InitializePlayerHero
--------------------------------------------------------------------------------
function GameMode:Think_InitializePlayerHero( hPlayerHero )
	if not hPlayerHero then
		return 0.1
	end

	if self.m_bPlayerDataCaptured == false then
		if hPlayerHero:GetUnitName() == self.m_sHeroSelection then
			local nPlayerID = hPlayerHero:GetPlayerOwnerID()
			PlayerResource:ModifyGold( nPlayerID, 99999, true, 0 )
			self.m_bPlayerDataCaptured = true
		end
	end

	if self.m_bInvulnerabilityEnabled then
		local hAllPlayerUnits = {}
		hAllPlayerUnits = hPlayerHero:GetAdditionalOwnedUnits()
		hAllPlayerUnits[ #hAllPlayerUnits + 1 ] = hPlayerHero

		for _, hUnit in pairs( hAllPlayerUnits ) do
			hUnit:AddNewModifier( hPlayerHero, nil, "lm_take_no_damage", nil )
		end
	end

	return
end

--------------------------------------------------------------------------------
-- Think_InitializeNeutralCaster
--------------------------------------------------------------------------------
function GameMode:Think_InitializeNeutralCaster( neutralCaster )
	if not neutralCaster then
		return 0.1
	end

	print( "neutralCaster:AddAbility( \"la_spawn_enemy_at_target\" )" )
	neutralCaster:AddAbility( "la_spawn_enemy_at_target" )
	return
end

--------------------------------------------------------------------------------
-- Think_InitializeNeutralCaster
--------------------------------------------------------------------------------
function GameMode:Think_InitializeCustomUI( neutralCaster )
	if not neutralCaster then
		return 0.1
	end

	print( "neutralCaster:AddAbility( \"la_spawn_enemy_at_target\" )" )
	neutralCaster:AddAbility( "la_spawn_enemy_at_target" )
	return
end

--------------------------------------------------------------------------------
-- GameEvent: OnItemPurchased
--------------------------------------------------------------------------------
function GameMode:OnItemPurchased( event )
	local hBuyer = PlayerResource:GetPlayer( event.PlayerID )
	local hBuyerHero = hBuyer:GetAssignedHero()
	hBuyerHero:ModifyGold( event.itemcost, true, 0 )
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCReplaced
--------------------------------------------------------------------------------
function GameMode:OnNPCReplaced( event )
	local sNewHeroName = PlayerResource:GetSelectedHeroName( event.new_entindex )
	print( "sNewHeroName == " .. sNewHeroName ) -- we fail to get in here
	self:BroadcastMsg( "Changed hero to " .. sNewHeroName )
end

--------------------------------------------------------------------------------
-- GameEvent: OnEntityKilled
--------------------------------------------------------------------------------
function GameMode:OnEntityKilled( keys )
	local killedEntity = EntIndexToHScript( keys.entindex_killed )

	if killedEntity:IsHero() and keys.entindex_attacker ~= nil then
	    local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	    local teamkills = PlayerResource:GetTeamKills(killerEntity:GetTeamNumber())
	    if teamkills >= 2 and not GameRules:IsCheatMode() then
	      GameRules:SetCustomVictoryMessage( "Thanks for playing!" )
		  GameRules:SetCustomVictoryMessageDuration( 3.0 )
		  GameRules:SetGameWinner( killerEntity:GetTeamNumber() )
	    end
	end
	if killedEntity:IsBuilding() and keys.entindex_attacker ~= nil then
		local killerEntity = EntIndexToHScript( keys.entindex_attacker )
		if not GameRules:IsCheatMode() then
	      GameRules:SetCustomVictoryMessage( "Thanks for playing!" )
		  GameRules:SetCustomVictoryMessageDuration( 3.0 )
		  GameRules:SetGameWinner( killerEntity:GetTeamNumber() )
	    end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnWelcomePanelDismissed
--------------------------------------------------------------------------------
function GameMode:OnWelcomePanelDismissed( event )
	print( "Entering GameMode:OnWelcomePanelDismissed( event )" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnRefreshButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnRefreshButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_dev hero_refresh" )
	self:BroadcastMsg( "#Refresh_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnLevelUpButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnLevelUpButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_dev hero_level 1" )
	self:BroadcastMsg( "#LevelUp_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnMaxLevelButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnMaxLevelButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	hPlayerHero:AddExperience( 32400, false, false ) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced
	--while hPlayerHero:GetLevel() < 25 do
		--hPlayerHero:HeroLevelUp( false )
	--end

	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local hAbility = hPlayerHero:GetAbilityByIndex( i )
		if hAbility and hAbility:CanAbilityBeUpgraded () == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden() then
			while hAbility:GetLevel() < hAbility:GetMaxLevel() do
				hPlayerHero:UpgradeAbility( hAbility )
			end
		end
	end

	hPlayerHero:SetAbilityPoints( 0 )
	self:BroadcastMsg( "#MaxLevel_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnFreeSpellsButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnFreeSpellsButtonPressed( eventSourceIndex )
	SendToServerConsole( "toggle dota_ability_debug" )
	if self.m_bFreeSpellsEnabled == false then
		self.m_bFreeSpellsEnabled = true
		SendToServerConsole( "dota_dev hero_refresh" )
		self:BroadcastMsg( "#FreeSpellsOn_Msg" )
	elseif self.m_bFreeSpellsEnabled == true then
		self.m_bFreeSpellsEnabled = false
		self:BroadcastMsg( "#FreeSpellsOff_Msg" )
	end	
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnInvulnerabilityButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnInvulnerabilityButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	local hAllPlayerUnits = {}
	hAllPlayerUnits = hPlayerHero:GetAdditionalOwnedUnits()
	hAllPlayerUnits[ #hAllPlayerUnits + 1 ] = hPlayerHero

	if self.m_bInvulnerabilityEnabled == false then
		for _, hUnit in pairs( hAllPlayerUnits ) do
			hUnit:AddNewModifier( hPlayerHero, nil, "lm_take_no_damage", nil )
		end
		self.m_bInvulnerabilityEnabled = true
		self:BroadcastMsg( "#InvulnerabilityOn_Msg" )
	elseif self.m_bInvulnerabilityEnabled == true then
		for _, hUnit in pairs( hAllPlayerUnits ) do
			hUnit:RemoveModifierByName( "lm_take_no_damage" )
		end
		self.m_bInvulnerabilityEnabled = false
		self:BroadcastMsg( "#InvulnerabilityOff_Msg" )
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnAllyButtonPressed -- deprecated
--------------------------------------------------------------------------------
function GameMode:OnSpawnAllyButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	self.m_nAlliesCount = self.m_nAlliesCount + 1
	print( "Ally team count is now: " .. self.m_nAlliesCount )
	self.m_tAlliesList[ self.m_nAlliesCount ] = CreateUnitByName( "npc_dota_hero_puck", hPlayerHero:GetAbsOrigin(), true, nil, nil, self.m_nALLIES_TEAM )
	local hUnit = self.m_tAlliesList[ self.m_nAlliesCount ]
	hUnit:SetControllableByPlayer( self.m_nPlayerID, false )
	hUnit:SetRespawnPosition( hPlayerHero:GetAbsOrigin() )
	FindClearSpaceForUnit( hUnit, hPlayerHero:GetAbsOrigin(), false )
	hUnit:Hold()
	hUnit:SetIdleAcquire( false )
	hUnit:SetAcquisitionRange( 0 )
	self:BroadcastMsg( "#SpawnAlly_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: SpawnEnemyButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnSpawnEnemyButtonPressed( eventSourceIndex, data )
	if #self.m_tEnemiesList >= 100 then
		print( "#self.m_tEnemiesList == " .. #self.m_tEnemiesList )

		self:BroadcastMsg( "#MaxEnemies_Msg" )
		return
	end

    local hAbility = self._hNeutralCaster:FindAbilityByName( "la_spawn_enemy_at_target" )
	self._hNeutralCaster:CastAbilityImmediately( hAbility, -1 )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	local hAbilityTestSearch = hPlayerHero:FindAbilityByName( "la_spawn_enemy_at_target" )
	if hAbilityTestSearch then -- Testing whether AddAbility worked successfully on the lua-based ability
		print( "hPlayerHero:AddAbility( \"la_spawn_enemy_at_target\" ) was successful" )
	end

	self:BroadcastMsg( "#SpawnEnemy_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnLevelUpEnemyButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnLevelUpEnemyButtonPressed( eventSourceIndex )
	for k, v in pairs( self.m_tEnemiesList ) do
		self.m_tEnemiesList[ k ]:HeroLevelUp( false )
	end
	self:BroadcastMsg( "#LevelUpEnemy_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnDummyTargetsButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnDummyTargetsButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	self.m_nDummiesCount = self.m_nDummiesCount + 1
	print( "Dummy team count is now: " .. self.m_nDummiesCount )
	self.m_tDummiesList[ self.m_nDummiesCount ] = CreateUnitByName( "npc_dota_target_dummy_ORIGINAL", hPlayerHero:GetAbsOrigin(), true, nil, nil, self.m_nDUMMIES_TEAM )
	local hUnit = self.m_tDummiesList[ self.m_nDummiesCount ]
	hUnit:SetControllableByPlayer( self.m_nPlayerID, false )
	FindClearSpaceForUnit( hUnit, hPlayerHero:GetAbsOrigin(), false )
	hUnit:Hold()
	hUnit:SetIdleAcquire( false )
	hUnit:SetAcquisitionRange( 0 )
	self:BroadcastMsg( "#SpawnDummyTarget_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnRemoveSpawnedUnitsButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnRemoveSpawnedUnitsButtonPressed( eventSourceIndex )
	print( "Entering GameMode:OnRemoveSpawnedUnitsButtonPressed( eventSourceIndex )" )
	PrintTable( self.m_tAlliesList, " " )
	for k, v in pairs( self.m_tAlliesList ) do
		self.m_tAlliesList[ k ]:Destroy()
		self.m_tAlliesList[ k ] = nil
	end
	PrintTable( self.m_tEnemiesList, " " )
	for k, v in pairs( self.m_tEnemiesList ) do
		self.m_tEnemiesList[ k ]:Destroy()
		self.m_tEnemiesList[ k ] = nil
	end
	PrintTable( self.m_tDummiesList, " " )
	for k, v in pairs( self.m_tDummiesList ) do
		self.m_tDummiesList[ k ]:Destroy()
		self.m_tDummiesList[ k ] = nil
	end

	self.m_nEnemiesCount = 0
	self.m_nDummiesCount = 0

	self:BroadcastMsg( "#RemoveSpawnedUnits_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnLaneCreepsButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnLaneCreepsButtonPressed( eventSourceIndex )
	SendToServerConsole( "toggle dota_creeps_no_spawning" )
	if self.m_bCreepsEnabled == false then
		self.m_bCreepsEnabled = true
		self:BroadcastMsg( "#LaneCreepsOn_Msg" )
	elseif self.m_bCreepsEnabled == true then
		-- if we're disabling creep spawns, then also kill existing creep waves
		SendToServerConsole( "dota_kill_creeps radiant" )
		SendToServerConsole( "dota_kill_creeps dire" )
		self.m_bCreepsEnabled = false
		self:BroadcastMsg( "#LaneCreepsOff_Msg" )
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnChangeCosmeticsButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnChangeCosmeticsButtonPressed( eventSourceIndex )
	-- currently running the command directly in XML, should run it here if possible
	-- can use GetSelectedHeroID
end

--------------------------------------------------------------------------------
-- GameEvent: OnChangeHeroButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnChangeHeroButtonPressed( eventSourceIndex )
	-- Clean up enemies
	for _,unit in pairs(HeroList:GetAllHeroes()) do
		if PlayerResource:IsFakeClient(unit:GetPlayerOwnerID()) then

		else 
			
		end
	end
	self.m_tEnemiesList = {}
	
	GameRules:SetHeroSelectionTime(3)
	GameRules:ResetToHeroSelection()
end

--------------------------------------------------------------------------------
-- GameEvent: OnPauseButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnPauseButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_pause" )
end

--------------------------------------------------------------------------------
-- GameEvent: OnLeaveButtonPressed
--------------------------------------------------------------------------------
function GameMode:OnLeaveButtonPressed( eventSourceIndex )
	GameRules:SetCustomVictoryMessage( "Thanks for playing!" )
	GameRules:SetCustomVictoryMessageDuration( 3.0 )
	GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
end