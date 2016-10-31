function RefreshCooldowns( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local damageType = ability:GetAbilityDamageType()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local max_targets = ability:GetLevelSpecialValueFor("targets", ability:GetLevel() - 1)
	
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	local ability3 = caster:GetAbilityByIndex(2)
	local ability4 = caster:GetAbilityByIndex(3)
	
	local ability1CD = ability1:GetCooldownTimeRemaining()
	local ability2CD = ability2:GetCooldownTimeRemaining()
	local ability3CD = ability3:GetCooldownTimeRemaining()
	local ability4CD = ability4:GetCooldownTimeRemaining()
	
	
	ability1:EndCooldown()
	ability2:EndCooldown()
	ability3:EndCooldown()
	ability4:EndCooldown()

	-- refreshes mana values on display
	ability4:SetLevel(ability4:GetLevel())

	local cooldown = ability1CD + ability2CD + ability3CD + ability4CD + 5
	damage = damage * cooldown
	amount = math.floor(damage)

	ability:StartCooldown(cooldown)
	caster:RemoveModifierByName("modifier_alternating_current_stacks")
	caster:RemoveModifierByName("modifier_alternating_current_stacks_0")
	caster:RemoveModifierByName("modifier_alternating_current_stacks_1")
	caster:RemoveModifierByName("modifier_alternating_current_stacks_2")

	--PopupCircuitDamage(keys, caster, amount)
	ApplyDamage({ victim = caster, attacker = caster, damage = damage, damage_type = damageType })

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)

	for i = 1, #targets do
		if not targets[i]:IsMagicImmune() then
			ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_short_circuit", {})
			Timers:CreateTimer( 0.1, function()
				if targets[i]:TriggerSpellAbsorb(ability) then
					RemoveLinkens(targets[i])
				else
					PopupCircuitDamage(keys, targets[i], amount)
					ApplyDamage({ victim = targets[i], attacker = caster, ability = ability, damage = damage, damage_type = damageType })
				end
			end)
			max_targets = max_targets - 1
			if max_targets < 1 then break end
		end
	end
end

function PopupCircuitDamage(keys, target, amount)
    local caster = keys.caster
    local ability = keys.ability
    local damageType = ability:GetAbilityDamageType()

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
    amount = math.floor(amount)

    PopupNumbers(target, "damage", Vector(255, 0, 0), 2.0, amount, nil, POPUP_SYMBOL_POST_LIGHTNING)
end

function RefreshShortCircuit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local heal = ability:GetLevelSpecialValueFor("heal", ability:GetLevel() - 1)

	local ulti_ability = caster:FindAbilityByName("alpha_strider_short_circuit")
	local ulti_abilityCD = ulti_ability:GetCooldownTimeRemaining()

	ulti_ability:EndCooldown()
	ability:StartCooldown(ulti_abilityCD + 5)

	heal = heal * ulti_abilityCD
	amount = math.floor(heal)
	PopupNumbers(caster, "heal", Vector(55, 255, 55), 2.0, amount, POPUP_SYMBOL_PRE_PLUS, nil)
	caster:Heal(amount, ability)
end