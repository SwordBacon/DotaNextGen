 
function orochi_start_charge( keys )

    if keys.ability:GetLevel() ~= 1 then return end

    local caster = keys.caster
    local ability = keys.ability
    local modifierName = "modifier_orochi_stacks"
    local maximum_charges = ability:GetLevelSpecialValueFor( "orochi_max_charges", ( ability:GetLevel() - 1 ) )
    local charge_replenish_time = ability:GetLevelSpecialValueFor( "orochi_replenish_time", ( ability:GetLevel() - 1 ) )
    local charge_ready = true
    ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
    orochi_particle = ParticleManager:CreateParticle("particles/onimusha/fx_onimusha_orochi/onimusha_orochi_01.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)


    Timers:CreateTimer(0, function()
        local stack_count = caster:GetModifierStackCount(modifierName, ability)
        print(stack_count)
        if stack_count ~= maximum_charges and charge_ready == true and ability:IsCooldownReady() then
            ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
            caster:SetModifierStackCount( modifierName, caster, maximum_charges )
            charge_ready = false
            orochi_particle = ParticleManager:CreateParticle("particles/onimusha/fx_onimusha_orochi/onimusha_orochi_01.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            print(orochi_particle)
            return 0.5
        elseif caster:HasModifier("modifier_orochi_bloodlust") then
            charge_ready = true
            ParticleManager:DestroyParticle(orochi_particle, false)
            return 0.5
        else
            return 0.5
        end
    end)
end

function orochi_On_Atk( keys )
    local modifierName = "modifier_orochi_stacks"
    local AttackDamage = keys.DamageDealt
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local next_charge = caster.orochi_charges
    local charge_replenish_time = ability:GetLevelSpecialValueFor( "orochi_replenish_time", ( ability:GetLevel() - 1 ) )
    caster.orochi_charges = caster:GetModifierStackCount(modifierName, ability)
   
    if caster.orochi_charges > 1 then
        local damage_table = {}
            damage_table.attacker = caster
            damage_table.ability = ability
            damage_table.damage_type = ability:GetAbilityDamageType()
            damage_table.victim = target

        damage_table.damage = AttackDamage
        ApplyDamage(damage_table)
		if target:IsHero() then
            caster.orochi_charges = caster.orochi_charges - 1
            ParticleManager:DestroyParticle(orochi_particle, false)
            orochi_particle = ParticleManager:CreateParticle("particles/onimusha/fx_onimusha_orochi/onimusha_orochi_0" .. (6 - caster.orochi_charges) .. ".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            caster:SetModifierStackCount( modifierName, caster, caster.orochi_charges )
		end
    elseif caster.orochi_charges == 1 then 
        local damage_table = {}
            damage_table.attacker = caster
            damage_table.ability = ability
            damage_table.damage_type = ability:GetAbilityDamageType()
            damage_table.victim = target

        damage_table.damage = AttackDamage
        ApplyDamage(damage_table)
       
        if ability:IsCooldownReady() and target:IsHero() then
            caster.orochi_charges = caster.orochi_charges - 1
            caster:RemoveModifierByName(modifierName)
            keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_orochi_bloodlust", {})
            ability:StartCooldown(charge_replenish_time)
        end
    end
end

function DemonForm( keys )
    local caster = keys.caster
    local model = keys.model
    if caster.caster_model == nil then 
        caster.caster_model = caster:GetModelName()
    end
    caster.caster_attack = caster:GetAttackCapability()

    caster:SetOriginalModel(model)

    print("DEMON")
end

function HumanForm( keys )
    local caster = keys.caster

    caster:SetModel(caster.caster_model)
    caster:SetOriginalModel(caster.caster_model)
    print("HUMAN")
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

        StopSoundOn("Hero_Juggernaut.Attack", target )
        StopSoundOn("Hero_Juggernaut.Attack.Rip", target )
        StopSoundOn("Hero_Juggernaut.Attack.Ring", target )

        caster:StopSound("Hero_Juggernaut.Attack")
        caster:StopSound("Hero_Juggernaut.Attack.Rip")
        caster:StopSound("Hero_Juggernaut.Attack.Ring")

        target:StopSound("Hero_Juggernaut.Attack")
        target:StopSound("Hero_Juggernaut.Attack.Rip")
        target:StopSound("Hero_Juggernaut.Attack.Ring")
    end)
end