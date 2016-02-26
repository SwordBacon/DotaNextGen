function GameMode:FilterExecuteOrder( filterTable )
    local units = filterTable["units"]
    local issuer = filterTable["issuer_player_id_const"]
    local order_type = filterTable["order_type"]
    local abilityIndex = filterTable["entindex_ability"]
    local ability = EntIndexToHScript(abilityIndex)
    local targetIndex = filterTable["entindex_target"]
    local target = EntIndexToHScript(targetIndex)



    for n, unit_index in pairs(units) do
        local unit = EntIndexToHScript(unit_index)

        --Store the caster's last spell.

        if (order_type == 5 or order_type == 6 or order_type == 7 or order_type == 8 or order_type == 9) then
            unit.lastability = ability
            unit.DidCast = true
        else
            unit.DidCast = false
        end
        local owner_ID = unit:GetPlayerOwnerID()
        -- Describing rules so I see what I'm doing, if they are true they will be handled
        local order_rule_0 = PlayerResource:IsValidPlayerID(issuer) and PlayerResource:IsValidPlayerID(owner_ID) and (owner_ID ~= issuer)  
        -- Basic rule, if this is false the order likely comes from an order here and I don't want those checked to prevent loops.
        local order_rule_1 = unit:HasModifier("modifier_blackout")
        -- Simple
        local order_rule_2 = (order_type == 4) and (unit:GetUnitName() == "npc_dota_hero_omniknight") and (unit:GetTeamNumber() == target:GetTeamNumber()) and (unit:FindAbilityByName("Argent_Smite"):GetLevel() > 0)
        -- 4 is attack target and 2 is move to target, the commands you issue when you click on an ally, depending on what settings you have set for denieing allies
        local order_rule_3 = (order_type == 4) and not (unit:GetUnitName() == "npc_dota_hero_omniknight") and (target:HasModifier("modifier_specially_deniable")) and (unit:GetTeamNumber() == target:GetTeamNumber())
        -- If an ally clicks on another ally with the modifier that would allow him to attack the other one
        local order_rule_4 = (unit:GetUnitName() == "npc_dota_hero_omniknight") and ((order_type ~= 4) or (unit:GetTeamNumber() ~= target:GetTeamNumber())) 
       
        --[[if not order_rule_1 and not order_rule_2 and not order_rule_3 and not order_rule_4 then
            return true 
        else]]if order_rule_1 then
            local random = RandomFloat(0, 1) * 100
            local chance = blackout:GetLevelSpecialValueFor("halt_chance", blackout:GetLevel() -1)

            if random < chance then
                unit:Stop()
                blackout:ApplyDataDrivenModifier(skoros, unit, "modifier_block_commands", {duration = blackout:GetLevelSpecialValueFor("halt_duration",blackout:GetLevel() -1)})
                return false
            end
        elseif order_rule_2 then
            local Argent_Smite = unit:FindAbilityByName("Argent_Smite")
            Argent_Smite:ApplyDataDrivenModifier(unit,target,"modifier_specially_deniable",{duration = -1})
            Argent_Smite:ApplyDataDrivenModifier(unit,unit,"modifier_argent_smite",{duration = -1})
            return true
            

        elseif order_rule_3 then
            unit:MoveToNPC(target)
            return false
        elseif order_rule_4 then
            unit:RemoveModifierByName("modifier_argent_smite")
            return true
        else
            return true 
        end
    end
end
