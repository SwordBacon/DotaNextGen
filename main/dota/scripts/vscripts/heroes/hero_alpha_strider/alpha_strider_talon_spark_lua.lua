alpha_strider_talon_spark_lua = class ({})

LinkLuaModifier( "modifier_static_charge", "heroes/hero_alpha_strider/modifiers/modifier_static_charge.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_static_charge_slow", "heroes/hero_alpha_strider/modifiers/modifier_static_charge_slow.lua" ,LUA_MODIFIER_MOTION_NONE )


function alpha_strider_talon_spark_lua:GetManaCost( hTarget )
	local manaCost = self.BaseClass.GetManaCost( self, hTarget )
	return manaCost + (30*(self:GetCaster():GetModifierStackCount("modifier_alternating_current_stacks_2", self:GetCaster())))
end

function alpha_strider_talon_spark_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function alpha_strider_talon_spark_lua:OnSpellStart()
	local caster = self:GetCaster()

	if caster == nil then
		return
	end

	if not IsServer() then return end

	local ability = caster:FindAbilityByName("alpha_strider_alternating_current")
	
	if ability then 
		self:EndCooldown()
		self:CooldownSwap()
		ability:SetLevel(ability:GetLevel())
	end

	ability = self

	local mana = ability:GetLevelSpecialValueFor("mana_restore", ability:GetLevel() - 1)
	local bonusMana = ability:GetLevelSpecialValueFor("bonus_restore", ability:GetLevel() - 1)
	local burnAmount = ability:GetLevelSpecialValueFor("burn_amount", ability:GetLevel() - 1) / 100
	local modifierName = "modifier_static_charge"
	local modifierCount = caster:GetModifierStackCount(modifierName, caster)

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	
	mana = (bonusMana * modifierCount) + mana
	caster:GiveMana(mana)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_shockwave.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	caster:EmitSound("Hero_Magnataur.ShockWave.Target")

	
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	burnAmount = mana * burnAmount
	for _,v in pairs(targets) do
		self:PopupSparkBurn(v, burnAmount)
		v:ReduceMana(burnAmount)
	end
end

function alpha_strider_talon_spark_lua:PopupSparkBurn(target, burn_amount)
    local caster = self:GetCaster()
    local ability = self
    local amount = math.floor(burn_amount)

    if target:GetMana() > 0 then
    	PopupNumbers(target, "mana_loss", Vector(0, 153, 255), 2.0, amount, POPUP_SYMBOL_PRE_MINUS, nil)
    end
end

function alpha_strider_talon_spark_lua:CooldownSwap()
	local caster = self:GetCaster()
	local ability = self
	if not caster.abilityLast then caster.abilityLast = ability end

	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local check = false

	local index = ability:GetAbilityIndex()
	local modifierStacks = "modifier_alternating_current_stacks_" .. index
	
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	local ability3 = caster:GetAbilityByIndex(2)
	local ability4 = caster:FindAbilityByName("alpha_strider_alternating_current")
	
	while check == false do
		local randomInt = RandomInt(0,3)
		local abilityCD = caster:GetAbilityByIndex(randomInt)
		
		if abilityCD:GetLevel() > 0 and abilityCD ~= ability then
			ability:EndCooldown()
			cooldown = cooldown + abilityCD:GetCooldownTimeRemaining()
			if cooldown > 60 then cooldown = 60 end
			abilityCD:StartCooldown(cooldown)

			if caster.abilityLast == ability then
				if not caster:HasModifier(modifierStacks) then
					ability4:ApplyDataDrivenModifier(caster, caster, modifierStacks, {})
				end
				stack_count = caster:GetModifierStackCount(modifierStacks, ability)
				caster:SetModifierStackCount(modifierStacks, ability, stack_count + 1)
			else 
				caster.abilityLast = ability
				caster:RemoveModifierByName("modifier_alternating_current_stacks_0")
				caster:RemoveModifierByName("modifier_alternating_current_stacks_1")
				caster:RemoveModifierByName("modifier_alternating_current_stacks_2")
				ability4:ApplyDataDrivenModifier(caster, caster, modifierStacks, {})
				stack_count = caster:GetModifierStackCount(modifierStacks, ability)
				caster:SetModifierStackCount(modifierStacks, ability, stack_count + 1)
			end
			check = true
		end
	end
end