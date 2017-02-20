-- Generated from template

require("internal/util")
require('gamemode')


function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]
  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  -- PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  -- PrecacheResource("particle_folder", "particles/test_particle", context)
  PrecacheResource("particle", "particles/item_throwing_knives.vpcf", context)
  -- PrecacheResource("particle_folder", "particles", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  -- PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  -- PrecacheModel("models/heroes/viper/viper.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_abaddon.vsndevts", context)

  PrecacheModel("models/heroes/omniknight/hammer.vmdl", context)
  PrecacheModel("models/creeps/neutral_creeps/n_creep_vulture_a/n_creep_vulture_a.vmdl", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  -- PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_xarax_trick_box_1", context)
  PrecacheItemByNameSync("item_xarax_trick_box_2", context)
  PrecacheItemByNameSync("item_xarax_trick_box_3", context)
  PrecacheItemByNameSync("item_xarax_trap_door", context)
  PrecacheItemByNameSync("item_xarax_devils_cape", context)
  PrecacheItemByNameSync("item_gravity_blade", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_axe", context)
  PrecacheUnitByNameSync("npc_dota_hero_puck", context)
  PrecacheUnitByNameSync("npc_dota_hero_obsidian_destroyer",context)

  -- Custom heroes
  -- PrecacheUnitByNameSync("npc_dota_hero_venomancer",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_bounty_hunter",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_enchantress",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_riki",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_skywrath_mage",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_phoenix",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_disruptor",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_skeleton_king",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_nyx_assassin",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_juggernaut",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_bloodseeker",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_bristleback",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_visage",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_clinkz",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_gyrocopter",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_sand_king",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_omniknight",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_naga_siren",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_phantom_assassin",context)
  -- PrecacheUnitByNameSync("npc_dota_hero_bane",context)

end

-- Create the game mode when we activate
function Activate()
  print("Activate")
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()

  local mode = GameRules:GetGameModeEntity()
  mode:SetBotThinkingEnabled( true )
  --mode:SetBotsAlwaysPushWithHuman( true )   

  ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameStateChanged' ), self )
end

function GameMode:OnGameStateChanged( keys )
    local state = GameRules:State_Get()

    if state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        local num = 0
        local used_hero_name = "npc_dota_hero_luna"
        
        for i=0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayer(i) then
                print(i)
                
                -- Random heroes for people who have not picked
                if PlayerResource:HasSelectedHero(i) == false then
                    print("Randoming hero for:", i)
                    
                    local player = PlayerResource:GetPlayer(i)
                    player:MakeRandomHeroSelection()
                    
                    local hero_name = PlayerResource:GetSelectedHeroName(i)
                    
                    print("Randomed:", hero_name)
                end
                
                used_hero_name = PlayerResource:GetSelectedHeroName(i)
                num = num + 1
            end
        end
        
        self.numPlayers = num
        print("Number of players:", num)

        -- Eanble bots and fill empty slots
        if IsServer() == true and 10 - self.numPlayers > 0 then
            print("Adding bots in empty slots")
            
            for i=1, 5 do
                Tutorial:AddBot(used_hero_name, "", "", true)
                Tutorial:AddBot(used_hero_name, "", "", false)
            end
            
            GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
            --SendToServerConsole("dota_bot_set_difficulty 2")
            --SendToServerConsole("dota_bot_populate")
            --SendToServerConsole("dota_bot_set_difficulty 2")
        end
    elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
      Tutorial:StartTutorialMode()
--      for i=0, DOTA_MAX_TEAM_PLAYERS do`
--          print(i)
--          if PlayerResource:IsFakeClient(i) then
--              print(i)
--              PlayerResource:GetPlayer(i):GetAssignedHero():SetBotDifficulty(2)
--          end
--      end
    end
end

