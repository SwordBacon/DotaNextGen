function BeginCooldown( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not abilityLast then abilityLast = ability end
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local check = false
	
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	local ability3 = caster:GetAbilityByIndex(2)
	local ability4 = caster:GetAbilityByIndex(3)
	
	while check == false do
		local randomInt = RandomInt(0,3)
		local abilityCD = caster:GetAbilityByIndex(randomInt)
		
		if abilityCD:GetLevel() > 0 and abilityCD ~= ability then
			ability:EndCooldown()
			if ability:GetName() == "alpha_strider_plasma_leap" then
				ability:StartCooldown(0.85)
			end
			cooldown = cooldown + abilityCD:GetCooldownTimeRemaining()
			if cooldown > 60 then cooldown = 60 end
			abilityCD:StartCooldown(cooldown)

			if abilityLast == ability then
				if not caster:HasModifier("modifier_alternating_current_stacks") then
					ability4:ApplyDataDrivenModifier(caster, caster, "modifier_alternating_current_stacks", {Duration = duration})
				end
				stack_count = caster:GetModifierStackCount("modifier_alternating_current_stacks", ability)
				mana_spent = (ability:GetManaCost(-1) * stack_count) / 5
				caster_mana = caster:GetMana()
				caster:SetModifierStackCount("modifier_alternating_current_stacks", ability, stack_count + 1)
				caster:ReduceMana(mana_spent)
				if caster_mana < mana_spent then
					ApplyDamage({ victim = caster, attacker = caster, damage = mana_spent - caster_mana, damage_type = DAMAGE_TYPE_PURE })
				end
			else 
				abilityLast = ability
				caster:RemoveModifierByName("modifier_alternating_current_stacks")
			end
			check = true
		end
	end
end

function CheckAghs( keys )
	local caster = keys.caster
	local ability = keys.ability

	local ulti_ability = caster:FindAbilityByName("alpha_strider_short_circuit")
	local ulti_level = ulti_ability:GetLevel()

	if caster:HasScepter() and ulti_level > 0 and not caster:HasItemInInventory("item_ultimate_scepter_permanent") then
		for i = 0, 5 do
			if caster:GetItemInSlot(i):GetName() == "item_ultimate_scepter" and ulti_level > 0 then
				local item = caster:GetItemInSlot(i)
				caster:RemoveItem(item)
				local newItem = CreateItem("item_ultimate_scepter_permanent", caster, caster )
				caster:AddItem(newItem)
				break
			end
		end
		caster:AddAbility("alpha_strider_second_circuit")
		aghs_ability = caster:FindAbilityByName("alpha_strider_second_circuit")
		aghs_ability:SetLevel(1)

		caster:SwapAbilities(ulti_ability:GetName(), aghs_ability:GetName(), true, true)
	end
end

function LevelRefresh(keys)
	keys.ability:SetLevel(keys.ability:GetLevel())
end