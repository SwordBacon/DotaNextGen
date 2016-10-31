function bleedDamage( event )
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local hpToDamage = ability:GetLevelSpecialValueFor("bleed_damage", ability:GetLevel() - 1) / 100
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = math.ceil(target:GetHealth() * hpToDamage),
        damage_type = DAMAGE_TYPE_PURE,
        }
    ApplyDamage(damageTable)
end

function takeDamage( event )
    local target = event.unit
    target.preHeal = target:GetHealth()
end

function anemicAura( event )
    local caster = event.caster
    local target = event.unit
    local ability = event.ability
    local auraLevel = ability:GetLevelSpecialValueFor("heal_reduction" , ability:GetLevel() - 1 ) --[[20 / 30 / 40 / 50]]

    if target.preHeal ~= nil and target:GetHealthPercent() <= 99 then
        local healAmount = target:GetHealth() - target.preHeal
        local reducedHeal = math.floor(healAmount * (auraLevel / 100))
        
        target:SetHealth(target:GetHealth() - reducedHeal)
        target.preHeal = target:GetHealth()
    end
end