alpha_strider_static_charge_lua = class ({})

LinkLuaModifier( "modifier_static_charge", "heroes/hero_alpha_strider/modifiers/modifier_static_charge.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_static_charge_slow", "heroes/hero_alpha_strider/modifiers/modifier_static_charge_slow.lua" ,LUA_MODIFIER_MOTION_NONE )


function alpha_strider_static_charge_lua:GetManaCost( hTarget )
	local manaCost = self.BaseClass.GetManaCost( self, hTarget )
	return manaCost + (10*(self:GetCaster():GetModifierStackCount("modifier_alternating_current_stacks_0", self:GetCaster())))
end

function alpha_strider_static_charge_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function alpha_strider_static_charge_lua:OnSpellStart()
	local hCaster = self:GetCaster()

	if hCaster == nil then
		return
	end

	if not IsServer() then return end

	local ability = hCaster:FindAbilityByName("alpha_strider_alternating_current")
	local modifierName = "modifier_alternating_current_stacks"
	
	if ability then 
		self:EndCooldown()
		self:CooldownSwap()
		ability:SetLevel(ability:GetLevel())
	end

	self:AddCharges()
	hCaster:EmitSound("Hero_Zuus.StaticField")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf",PATTACH_ABSORIGIN_FOLLOW,hCaster)
end

function alpha_strider_static_charge_lua:CooldownSwap()
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

function alpha_strider_static_charge_lua:AddCharges()
	local caster = self:GetCaster()
	local ability = self
	local modifierName = "modifier_static_charge"
	local mana = ability:GetManaCost(ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("buff_duration", ability:GetLevel() - 1)
	
	if not caster:HasModifier(modifierName) then
		caster:AddNewModifier(caster, ability, modifierName, {Duration = duration})
	end
	local modifierCount = caster:GetModifierStackCount(modifierName, caster)
	caster:SetModifierStackCount(modifierName, caster, modifierCount + 1)
end