--[[function aoeDamage( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ripLevel = ability:GetLevelSpecialValueFor("aoe_damage" , ability:GetLevel() - 1 ) --[4% / 6% / 8% / 10%]
    local damageTable = {
        attacker = caster,
        damage = math.ceil(target:GetHealth() * (ripLevel / 100)),
        damage_type = DAMAGE_TYPE_PURE,
        }

    local units_in_radius = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, 200, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), 0, 0, false)

    for _,v in pairs(units_in_radius) do
        damageTable.victim = v
        ApplyDamage(damageTable)
    end
end]]