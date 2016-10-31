function orochi_On_Atk( keys )
    local modifierName = "modifier_orochi_stacks"
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local charge_replenish_time = ability:GetLevelSpecialValueFor( "orochi_replenish_time", ( ability:GetLevel() - 1 ) )
    caster.orochi_charges = caster:GetModifierStackCount(modifierName, ability)
   
	if target:IsHero() then 
        if ability:IsCooldownReady() and not caster:HasModifier("modifier_orochi_bloodlust") then
            ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
            caster:SetModifierStackCount( modifierName, caster, caster.orochi_charges + 1 )
            caster.orochi_charges = caster:GetModifierStackCount(modifierName, ability)
            if caster.orochi_charges == 1 then
                orochi_particle = ParticleManager:CreateParticle("particles/onimusha/fx_onimusha_orochi/onimusha_orochi_0" .. (caster.orochi_charges + 1) .. ".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            elseif caster.orochi_charges > 1 and caster.orochi_charges < 6 then  
                ParticleManager:DestroyParticle(orochi_particle, false)
                orochi_particle = ParticleManager:CreateParticle("particles/onimusha/fx_onimusha_orochi/onimusha_orochi_0" .. caster.orochi_charges .. ".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            elseif ability:IsCooldownReady() and caster.orochi_charges == 6 then
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_orochi_bloodlust_delay", {Duration = 0.6})
                caster:StartGesture(ACT_DOTA_DIE)
                ability:StartCooldown(charge_replenish_time)
            end
        elseif caster:HasModifier("modifier_orochi_bloodlust") then
            ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_orochi_bloodlust", {})
        end
	end

    local damage_table = {}
   
    damage_table.victim = target
    damage_table.attacker = caster
    damage_table.ability = ability
    damage_table.damage = ability:GetLevelSpecialValueFor("bonus_damage", ability:GetLevel() - 1) * caster:GetModifierStackCount(modifierName, ability)
    damage_table.damage_type = ability:GetAbilityDamageType() 
   

    ApplyDamage(damage_table)

    local amount = damage_table.damage
    amount = amount - (amount * target:GetMagicalArmorValue())

    local lens_count = 0
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item ~= nil and item:GetName() == "item_aether_lens" then
            lens_count = lens_count + 1
        end
    end
    amount = amount * (1 + (.08 * lens_count))

    amount = math.floor(amount)

    if amount > 0 then
        PopupNumbers(target, "damage", Vector(153, 0, 153), 2.0, amount, nil, POPUP_SYMBOL_POST_EYE)
    end
end

function RemoveEffects( keys )
    keys.caster:RemoveModifierByName("modifier_orochi_bloodlust")
    ParticleManager:DestroyParticle(orochi_particle, false)
end

function DemonForm( keys )
    local caster = keys.caster
    local ability = keys.ability
    local model = keys.model
    if caster.caster_model == nil then
        caster.caster_model = caster:GetModelName()
    end
    caster.caster_attack = caster:GetAttackCapability()
    caster:SetOriginalModel(model)
    caster:SetModelScale(1.666)
    caster:RemoveGesture(ACT_DOTA_DIE)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_orochi_stacks", {})
end

function HumanForm( keys )
    local caster = keys.caster
    caster:SetModel(caster.caster_model)
    caster:SetOriginalModel(caster.caster_model)
    caster:SetModelScale(1.0)
end

--[[Author: Noya
    Date: 09.08.2015.
    Hides all dem hats
]]
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

function ShowWearables( event )
    local hero = event.caster

    for i,v in pairs(hero.hiddenWearables) do
        v:RemoveEffects(EF_NODRAW)
    end
end

function StartAttackSound( keys )
    local caster = keys.caster

    caster:EmitSound("Hero_WarlockGolem.PreAttack")
    Timers:CreateTimer(0.003, function()
        caster:StopSound("Hero_Juggernaut.PreAttack")
    end)
end

function FinishAttackSound( keys )
    local caster = keys.caster
    local target = caster:GetAttackTarget()

    EmitSoundOn("Hero_WarlockGolem.Attack", target )
    Timers:CreateTimer(0.01, function()

        --StopSoundOn("Hero_Juggernaut.Attack", target )
        StopSoundOn("Hero_Juggernaut.Attack.Rip", target )
        StopSoundOn("Hero_Juggernaut.Attack.Ring", target )

        --caster:StopSound("Hero_Juggernaut.Attack")
        caster:StopSound("Hero_Juggernaut.Attack.Rip")
        caster:StopSound("Hero_Juggernaut.Attack.Ring")

        --target:StopSound("Hero_Juggernaut.Attack")
        if target then
            target:StopSound("Hero_Juggernaut.Attack.Rip")
            target:StopSound("Hero_Juggernaut.Attack.Ring")
        end
    end)
end