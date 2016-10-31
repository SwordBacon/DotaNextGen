function AddCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_static_charge"
	local mana = ability:GetManaCost(ability:GetLevel() - 1)
	
	if not caster:HasModifier(modifierName) then
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
	end
	local modifierCount = caster:GetModifierStackCount(modifierName, caster)
	caster:SetModifierStackCount(modifierName, caster, modifierCount + 1)
end

function SpendCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifierName = "modifier_static_charge"
	local modifierCount = caster:GetModifierStackCount(modifierName, caster)
	
	local damage = ability:GetAbilityDamage()
	local shockDamage = damage * modifierCount

	local lens_count = 0
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item ~= nil and item:GetName() == "item_aether_lens" then
            lens_count = lens_count + 1
        end
    end

    if target:IsBuilding() then
		shockDamage = shockDamage / 2
	end

	local shockDamageModified = shockDamage * (1 + (.05 * lens_count) + ( .01 * caster:GetIntellect() / 16 )
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	local DamageTable = {
		victim = target,
		attacker = caster,
		ability = ability,
		damage = shockDamageModified,
		damage_type = DAMAGE_TYPE_MAGICAL
	}
	if target:TriggerSpellAbsorb(ability) then
		RemoveLinkens(target)
		caster:RemoveModifierByName(modifierName)
		return
	elseif not target:IsMagicImmune() then
		ApplyDamage(DamageTable)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_charge_slow", {Duration = duration})
		CalculateDamage(caster, target, shockDamage, DamageTable.damage_type)
		target:SetModifierStackCount("modifier_charge_slow", ability, modifierCount)
		if modifierCount > 10 then 
			target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = duration})
		end
		caster:RemoveModifierByName(modifierName)
		EmitSoundOn("Hero_Leshrac.Lightning_Storm", target)
		particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
        --shared control points for all the different lightnings
        ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000)) -- height of the bolt
        ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- point landing
        ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin()) -- point origin  
	end
end

function CalculateDamage( caster, target, amount, damageType )
	if damageType == DAMAGE_TYPE_MAGICAL then
        amount = amount - (amount * target:GetMagicalArmorValue())
    elseif damageType == DAMAGE_TYPE_PHYSICAL then
        amount = amount - (amount * target:GetPhysicalArmorValue())
    end


    local lens_count = 0
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item ~= nil and item:GetName() == "item_aether_lens" then
            lens_count = lens_count + 1
        end
    end
    amount = amount * (1 + (.05 * lens_count) + ( .01 * caster:GetIntellect() / 16 ))


    PopupNumbers(target, "damage", Vector(77, 200, 255), 2.0, math.floor(amount), nil, POPUP_SYMBOL_POST_LIGHTNING)
end