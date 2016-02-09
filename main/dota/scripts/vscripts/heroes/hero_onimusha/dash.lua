function Dash( keys )
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
 
    ProjectileManager:ProjectileDodge(caster)
    ability.Dash_direction = caster:GetForwardVector()
    ability.Dash_distance = ability:GetLevelSpecialValueFor("MovementRange",  ability_level )
    ability.Dash_distance_bl = ability:GetLevelSpecialValueFor("MovementRange_BL",  ability_level )
    ability.Dash_speed = (ability:GetLevelSpecialValueFor("DashMovementSpeed",  ability_level  ) * 1/30 )
    ability.Dash_traveled = 0
end
 
function MoveForward( keys )
    local caster = keys.caster
    local ability = keys.ability

    caster:AddNoDraw()
   
    if caster:HasModifier("modifier_orochi_bloodlust") then
        if ability.Dash_traveled <= ability.Dash_distance_bl then
            caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.Dash_direction * ability.Dash_speed)
            ability.Dash_traveled = ability.Dash_traveled + ability.Dash_speed
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_hide_dash", {})
        else
            caster:InterruptMotionControllers(true)
            caster:RemoveModifierByName("modifier_hide_dash")
            caster:RemoveNoDraw()
        end
   
    else
        if ability.Dash_traveled <= ability.Dash_distance then
            caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.Dash_direction * ability.Dash_speed)
            ability.Dash_traveled = ability.Dash_traveled + ability.Dash_speed
        else
            caster:InterruptMotionControllers(true)
            caster:RemoveModifierByName("modifier_hide_dash")
            caster:RemoveModifierByName("modifier_show_dash")
            caster:RemoveNoDraw()
        end
    end
       
end
 
 
function IntPlusAgi( keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local int_caster = caster:GetIntellect()
    local agi_caster = caster:GetAgility()
    local damage = ability:GetAbilityDamage()


    local damage_table = {}
   
    damage_table.victim = target
    damage_table.attacker = caster
    damage_table.ability = ability
    damage_table.damage = agi_caster + int_caster + damage
    damage_table.damage_type = ability:GetAbilityDamageType()
   

    ApplyDamage(damage_table)

 
end