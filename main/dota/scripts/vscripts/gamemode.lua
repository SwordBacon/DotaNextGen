-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
-- LinkLuaModifier("momentum_break_limit", "heroes/eurus/modifiers/momentum_break_limit.lua", LUA_MODIFIER_MOTION_NONE )

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false

_G.NEUTRAL_TEAM = 4 -- global const for neutral team int
_G.DOTA_MAX_ABILITIES = 16
_G.HERO_MAX_LEVEL = 25

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used for displaying popups for damage/status values
require('libraries/popups')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
-- require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
-- require('events')


-- linkens.lua for when linkens can block a spell's effects
require('linkens')
-- Cosmetics for some heroes
require('CosmeticLib')


--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]

-- "demo_hero_name" is a magic term, "default_value" means no string was passed, so we'd probably want to put them in hero selection
sHeroSelection = GameRules:GetGameSessionConfigValue( "demo_hero_name", "default_value" )
-- print( "sHeroSelection: " .. sHeroSelection )
GameRules.flags = LoadKeyValues('scripts/kv/flags.kv')

function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded(hero)
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]

function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  if not hero:IsIllusion() then
    if hero:GetUnitName() == "npc_dota_hero_rattletrap" then
      hero:UpgradeAbility(hero:FindAbilityByName("borus_Positive_Charge"))
      hero:UpgradeAbility(hero:FindAbilityByName("borus_Negative_Charge"))
      hero:SetAbilityPoints(1)
      borus_caster = hero
  	elseif hero:GetUnitName() == "npc_dota_hero_disruptor" then
  		  local Ability = hero:FindAbilityByName("alpha_strider_alternating_current")
  		  if Ability then
          print('innate found, leveling Reload')
          Ability:SetLevel(1)
          print('Reload leveled')
        end
    elseif hero:GetUnitName() == "npc_dota_hero_skeleton_king" then
      local Ability = hero:FindAbilityByName("zeros_innate")
      if Ability then
        print('innate found, leveling Reload')
        Ability:SetLevel(1)
        print('Reload leveled')
      end
    elseif hero:GetUnitName() == "npc_dota_hero_omniknight" then
      hero.hammer = true
      CosmeticLib:ReplaceWithSlotName( hero, "weapon", 4246 )
    end
  end

  --GameRules.Heroes[hero:GetPlayerID()] = hero
  --  hero.positions = {}

  playerHero = hero:GetPlayerOwner()
  if not playerHero then return end
  if playerHero.CheckUI == nil then playerHero.CheckUI = true end
  --print(playerHero.CheckUI)
  --print(playerHero)

  if playerHero.CheckUI == true then
    playerHero.CheckUI = false
    if GetMapName() == "hero_demo" then
      if GameRules:IsCheatMode() then
        Timers:CreateTimer(1.322, function() 
          CustomGameEventManager:Send_ServerToPlayer(playerHero, "map_check", event)
          if hero:IsRealHero() then
            --hero:ModifyGold(99999,true,0)
          end
          if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) == 0 then
            Tutorial:AddBot("npc_dota_hero_puck","", "", false)
          end
        end)
      end
    end
    Timers:CreateTimer(1.322, function()
      if PlayerResource:GetPlayerCount() == 1 and ( GetMapName() == "dota" or not GameRules:IsCheatMode() ) then
        ShowGenericPopupToPlayer(playerHero, "#popupReminderCheats", "#popupReminderCheatsDesc", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN)
        if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) == 0 then
          Tutorial:AddBot("npc_dota_hero_puck","", "", false)
        end
      else
        ShowGenericPopupToPlayer(playerHero, "#popupReminder", "#popupReminderDesc", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN)
      end
    end)
  end

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")
  Timers:CreateTimer({   --Putting a modifier on towers to prevent them from attacking units with the disconnected modifiers
    endTime = 61,
    callback = function()   
      if hero:GetUnitName() == npc_dota_hero_tinker then
        local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
          for _,unit in pairs(targets) do 
            if unit:IsTower() then
              local ability = hero:FindAbilityByName("Global_Disconnect")
              ability:ApplyDataDrivenModifier(hero, unit, "protect", {duration = -1})
            end
          end
        end
      end
    })]]
end
-- main think loop
function Think(  )
    local currTime = GameRules:GetGameTime()
    if IsServer() then
      for pID, hero in pairs(GameRules.Heroes) do
          if not hero:IsNull() then
              if not hero:IsIllusion() then
                --print(hero:GetUnitName())
                if not hero.positions[math.floor(currTime*100)/100] then
                    hero.positions[math.floor(currTime*100)/100] = hero:GetAbsOrigin()
                end
                for t, pos in pairs(hero.positions) do
                    if (currTime-t) > 4 then
                        hero.positions[t] = nil
                    else -- the rest of the times in the table are <= 4.
                        break
                    end
                end
              end
          end
      end
    end
end
--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  --[[Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)]]
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  print( "Hero Concepts Project is loaded." )	
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  
  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  -- GameMode:_InitGameMode()
  GameRules.Heroes = {}
  GameRules.Think = Timers:CreateTimer(function() Think() return 0.05 end) 
  GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1200 )
  require("events")

  ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
  -- ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( GameMode, "OnAbilityUsed" ), self )
  -- ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( GameMode, "OnItemPickUp"), self )
	
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  -- Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode,"FilterExecuteOrder"),self)
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode,"FilterDamage"),self)
  GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode,"FilterModifierGained"),self)
  --GameRules.SELECTED_UNITS = {}

  Convars:RegisterCommand( "keyvalues_reload", function(...) GameRules:Playtesting_UpdateAddOnKeyValues() end, "Update Keyvalues", FCVAR_CHEAT )

  if GetMapName() == "hero_demo" then
    
    require("utility_functions")
    GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )
    GameRules:GetGameModeEntity():SetFixedRespawnTime( 4 )
    --GameMode:SetBotThinkingEnabled( true ) -- the ConVar is currently disabled in C++
    -- Set bot mode difficulty: can try GameMode:SetCustomGameDifficulty( 1 )
    GameRules:SetPreGameTime( 0 )


    GameRules:SetUseUniversalShopMode( true )
    GameRules:SetSameHeroSelectionEnabled( true )

    -- Events
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameRulesStateChange' ), self )
    if GameRules:IsCheatMode() then
      ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( GameMode, "OnItemPurchased" ), self )
    end
    ListenToGameEvent( "npc_replaced", Dynamic_Wrap( GameMode, "OnNPCReplaced" ), self )
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, "OnEntityKilled" ), self )

    CustomGameEventManager:RegisterListener( "WelcomePanelDismissed", function(...) return self:OnWelcomePanelDismissed( ... ) end )
    CustomGameEventManager:RegisterListener( "RefreshButtonPressed", function(...) return self:OnRefreshButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "LevelUpButtonPressed", function(...) return self:OnLevelUpButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "MaxLevelButtonPressed", function(...) return self:OnMaxLevelButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "FreeSpellsButtonPressed", function(...) return self:OnFreeSpellsButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "InvulnerabilityButtonPressed", function(...) return self:OnInvulnerabilityButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "SpawnAllyButtonPressed", function(...) return self:OnSpawnAllyButtonPressed( ... ) end ) -- deprecated
    CustomGameEventManager:RegisterListener( "SpawnEnemyButtonPressed", function(...) return self:OnSpawnEnemyButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "LevelUpEnemyButtonPressed", function(...) return self:OnLevelUpEnemyButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "DummyTargetsButtonPressed", function(...) return self:OnDummyTargetsButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "RemoveSpawnedUnitsButtonPressed", function(...) return self:OnRemoveSpawnedUnitsButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "LaneCreepsButtonPressed", function(...) return self:OnLaneCreepsButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "ChangeHeroButtonPressed", function(...) return self:OnChangeHeroButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "ChangeCosmeticsButtonPressed", function(...) return self:OnChangeCosmeticsButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "PauseButtonPressed", function(...) return self:OnPauseButtonPressed( ... ) end )
    CustomGameEventManager:RegisterListener( "LeaveButtonPressed", function(...) return self:OnLeaveButtonPressed( ... ) end )

    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
    
    if GameRules:IsCheatMode() then
      SendToServerConsole( "sv_cheats 1" )
      SendToServerConsole( "dota_hero_god_mode 0" )
      SendToServerConsole( "dota_ability_debug 0" )
      SendToServerConsole( "dota_creeps_no_spawning 0" )
    end
    --SendToServerConsole( "dota_bot_mode 1" )

    self.m_sHeroSelection = sHeroSelection -- this seems redundant, but events.lua doesn't seem to know about sHeroSelection

    self.m_bPlayerDataCaptured = false
    self.m_nPlayerID = 0

    --self.m_nHeroLevelBeforeMaxing = 1 -- unused now
    --self.m_bHeroMaxedOut = false -- unused now
    
    self.m_nALLIES_TEAM = 2
    self.m_tAlliesList = {}
    self.m_nAlliesCount = 0

    self.m_nENEMIES_TEAM = 3
    self.m_tEnemiesList = {}

    self.m_nDUMMIES_TEAM = 4
    self.m_tDummiesList = {}
    self.m_nDummiesCount = 0
    self.m_bDummiesEnabled = true

    self.m_bFreeSpellsEnabled = false
    self.m_bInvulnerabilityEnabled = false
    self.m_bCreepsEnabled = true

    self.m_CheckUI = true

    local hNeutralSpawn = Entities:FindByName( nil, "neutral_caster_spawn" )
    self._hNeutralCaster = CreateUnitByName( "npc_dota_neutral_caster", hNeutralSpawn:GetAbsOrigin(), false, nil, nil, NEUTRAL_TEAM )

    if IsInToolsMode() then
      GameRules:SetCustomGameSetupTimeout( 0 ) -- skip the custom team UI with 0, or do indefinite duration with -1
      PlayerResource:SetCustomTeamAssignment( self.m_nPlayerID, self.m_nALLIES_TEAM ) -- put PlayerID 0 on Radiant team (== team 2)
    end
  end

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:OnConnectFull(keys)
  GameMode:CaptureGameMode()
   local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  local userID = keys.userid

  self.vUserIds = self.vUserIds or {}
  self.vUserIds[userID] = ply
end

function GameMode:CaptureGameMode()
  if mode == nil then
    -- Set GameMode parameters
    mode = GameRules:GetGameModeEntity()
	-- mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
	-- print("Bot Thinking Enabled")
  end
end


-- This is an example console command
--[[function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end]]--


function GameMode:FilterExecuteOrder( filterTable )
    local units = filterTable["units"]
    local issuer = filterTable["issuer_player_id_const"]
    local order_type = filterTable["order_type"]
    local abilityIndex = filterTable["entindex_ability"]
    local ability = EntIndexToHScript(abilityIndex)
    local targetIndex = filterTable["entindex_target"]

    -- Skoros order filters
    local findSkorosArbalest = require('heroes/hero_skoros/arbalest')
    arbalest(filterTable)
    local findSkorosBlackout = require('heroes/hero_skoros/blackout')
    blackout(filterTable)
    local findSkorosNexus = require('heroes/hero_skoros/nexus')
    nexusOrder(filterTable)


    -- Proteus order filters
    local findProteusJet = require('heroes/hero_proteus/proteus_jet')
    jetOrder(filterTable)

    if filterTable.position_x then
        orderVector = Vector(filterTable.position_x,filterTable.position_y,filterTable.position_z)
    end

    local unit = EntIndexToHScript(units["0"])
    local target = EntIndexToHScript(targetIndex)

    if unit and target then
      -- Uther Argent Smite
      local utherArgentSmite = require('heroes/hero_uther/argent_smite')
      AllowAlliedAttacks(unit,target,order_type)
      if CancelOtherAlliedAttacks(unit,target,order_type) == false then
          return false
      end
      StopAllowingAlliedAttacks(unit,target,order_type)
    end
    
    return true
end

function GameMode:FilterDamage( filterTable )
  --DeepPrintTable(filterTable)

  local damageFilterTable = {}

  local attackerIndex = filterTable["entindex_attacker_const"]
  if attackerIndex then
    damageFilterTable.attacker = EntIndexToHScript(attackerIndex)
  end
  
  local victimIndex = filterTable["entindex_victim_const"]
  if victimIndex then
    damageFilterTable.victim = EntIndexToHScript(victimIndex)
  end

  local inflictorIndex = filterTable["entindex_inflictor_const"]
  if inflictorIndex then
    damageFilterTable.inflictor = EntIndexToHScript(inflictorIndex)
  end

  local damageType = filterTable["damagetype_const"]
  local damage = filterTable["damage"]

  local utherArgentSmite = require('heroes/hero_uther/argent_smite')
  damageFilterArgentSmite(filterTable)
  
  return true
end

function GameMode:FilterModifierGained( filterTable )

  local modifierCasterIndex = filterTable["entindex_caster_const"]
  if modifierCasterIndex then local 
    modifierCaster = EntIndexToHScript(modifierCasterIndex) 
  end
  local modifierAbilityIndex = filterTable["entindex_ability_const"]
  if modifierAbilityIndex then
    local modifierAbility = EntIndexToHScript(modifierAbilityIndex)
  end
  local modifierDuration = filterTable["duration"]
  local modifierTargetIndex =  filterTable["entindex_parent_const"]
  local modifierTarget = EntIndexToHScript(modifierTargetIndex)
  local modifierName = filterTable["name_const"]

  --Uther Argent Smite
  if modifierCaster then
    local utherArgentSmite = require('heroes/hero_uther/argent_smite')
    if argentSmiteDoNotDebuffAllies(filterTable) == false then
      return false
    end
  end

  return true
end


function CDOTABaseAbility:HasAbilityFlag(flag)
    if GameRules.flags[flag][self:GetAbilityName()] then
        return true
    else
        return false
    end
end

function CDOTA_BaseNPC:FindItemByName(item_name)
    for i=0,5 do
        local item = self:GetItemInSlot(i)
        if item and item:GetAbilityName() == item_name then
            return item
        end
    end
    return nil
end

function CDOTA_BaseNPC:GetAttackTimeRemaining()
    local lastAttack = self:GetLastAttackTime()
    local gametime = GameRules:GetGameTime()

    local attackSpan = gametime - lastAttack

    local lastAttackTime = self:GetSecondsPerAttack() - attackSpan

    if lastAttackTime < 0 then lastAttackTime = 0 end
    return lastAttackTime
end

function GameMode:DebugCalls()
    if not GameRules.DebugCalls then
        print("Starting DebugCalls")
        GameRules.DebugCalls = true

        debug.sethook(function(...)
            local info = debug.getinfo(2)
            local src = tostring(info.short_src)
            local name = tostring(info.name)
            if name ~= "__index" then
                print("Call: ".. src .. " -- " .. name)
            end
        end, "c")
    else
        print("Stopped DebugCalls")
        GameRules.DebugCalls = false
        debug.sethook(nil, "c")
    end
end

function GameMode:OnPlayerChat(keys)
  local text = keys.text
  local userID = keys.userid
    local playerID = self.vUserIds[userID] and self.vUserIds[userID]:GetPlayerID()
    if not playerID then return end

    -- Handle '-command'
    if StringStartsWith(text, "-") then
        text = string.sub(text, 2, string.len(text))
    end

  local input = split(text)
  local command = input[1]
  if DEBUG_CODES[command] then
        DEBUG_CODES[command](input[2])
  end        
end

function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

function StringStartsWith( fullstring, substring )
    local strlen = string.len(substring)
    local first_characters = string.sub(fullstring, 1 , strlen)
    return (first_characters == substring)
end

DEBUG_CODES = {
    ["debug_trees"] = function(...) GameMode:DebugTrees(...) end,           -- Prints the trees marked as pathable
    ["debug_blight"] = function(...) GameMode:DebugBlight(...) end,         -- Prints the positions marked for undead buildings
    ["debug_food"] = function(...) GameMode:DebugFood(...) end,             -- Prints the food count for all players, checking for inconsistencies
    ["debug_c"] = function(...) GameMode:DebugCalls(...) end,               -- Spams the console with every lua call
    ["debug_l"] = function(...) GameMode:DebugLines(...) end,               -- Spams the console with every lua line
}
