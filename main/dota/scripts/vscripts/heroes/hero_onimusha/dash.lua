function Dash( keys )
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local point = keys.target_points[ 1 ]


 
    ProjectileManager:ProjectileDodge(caster)
    ability.Dash_direction2 = caster:GetForwardVector()
    ability.Dash_direction = (point - caster:GetAbsOrigin()):Normalized()
    if (caster:GetAbsOrigin() - point):Length() == 0 then 
        ability.Dash_direction = caster:GetForwardVector()
    end
    ability.Dash_distance = ability:GetLevelSpecialValueFor("MovementRange",  ability_level )
    ability.Dash_distance_bl = ability:GetLevelSpecialValueFor("MovementRange_BL",  ability_level )
    ability.Dash_proj_speed = ability:GetLevelSpecialValueFor("DashMovementSpeed",  ability_level  )
    ability.Dash_speed = ability.Dash_proj_speed / 30
    ability.Dash_traveled = 0
    ability.AoE = ability:GetLevelSpecialValueFor("AoE",  ability_level )

    if caster:HasModifier("modifier_orochi_bloodlust") then
        ability.Dash_distance = ability.Dash_distance_bl
    end

    if caster:HasModifier("modifier_item_gravity_blade_pull") then
        caster:RemoveModifierByName("modifier_item_gravity_blade_pull") 
    end

    local projectileTable =
    {
        EffectName = "particles/onimusha_dash_terror.vpcf",
        Ability = ability,
        vSpawnOrigin = caster:GetAbsOrigin(),
        vVelocity = Vector( ability.Dash_direction.x * ability.Dash_proj_speed, ability.Dash_direction.y * ability.Dash_proj_speed, 0 ),
        fDistance = ability.Dash_distance,
        fStartRadius = ability.AoE,
        fEndRadius = ability.AoE,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = true,
        bProvidesVision = false,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    }

    projectile_id = ProjectileManager:CreateLinearProjectile( projectileTable )
end

function RemoveNoDraw( keys )
    keys.caster:RemoveNoDraw()
    if keys.caster:HasModifier("modifier_orochi_bloodlust") then
        HideWearables(keys)
        keys.caster:SetModelScale(1.66)
    else 
        keys.caster:SetModelScale(1.0)
    end
end

function HideWearables( event )
    local hero = event.caster
    local ability = event.ability

    hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end
 
function MoveForward( keys )
    local caster = keys.caster
    local ability = keys.ability

    caster:AddNoDraw()
    caster:SetModelScale(0.2)
   
    if ability.Dash_traveled <= ability.Dash_distance then
        caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.Dash_direction * ability.Dash_speed)
        ability.Dash_traveled = ability.Dash_traveled + ability.Dash_speed
    else
        caster:RemoveNoDraw()
        caster:InterruptMotionControllers(true)
        caster:RemoveModifierByName("modifier_hide_dash")
        caster:RemoveModifierByName("modifier_show_dash")
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