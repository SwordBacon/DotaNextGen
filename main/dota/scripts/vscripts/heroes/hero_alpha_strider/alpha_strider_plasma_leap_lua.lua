alpha_strider_plasma_leap_lua = class ({})

LinkLuaModifier( "modifier_plasma_leap", "heroes/hero_alpha_strider/modifiers/modifier_plasma_leap.lua" ,LUA_MODIFIER_MOTION_NONE )


function alpha_strider_plasma_leap_lua:GetManaCost( hTarget )
	local manaCost = self.BaseClass.GetManaCost( self, hTarget )
	return manaCost + (20*(self:GetCaster():GetModifierStackCount("modifier_alternating_current_stacks_1", self:GetCaster())))
end

function alpha_strider_plasma_leap_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function alpha_strider_plasma_leap_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	if caster == nil then
		return
	end

	-- Check innate
	local ability = caster:FindAbilityByName("alpha_strider_alternating_current")
	local modifierName = "modifier_alternating_current_stacks"
	
	-- Cooldown swap
	if ability then 
		self:EndCooldown()
		self:CooldownSwap()
		-- Refreshes mana display
		ability:SetLevel(ability:GetLevel())
	end

	-- Plasma Jump
	self.plasmaJumpRadius = self:GetSpecialValueFor( "radius" )
	self.plasmaJumpDamage = self:GetAbilityDamage()
	self.plasmaJumpDuration = self:GetSpecialValueFor( "duration" )

	if not IsServer() then return end

	ability = self
	caster:AddNewModifier( caster, ability, "modifier_plasma_leap", {} )
	caster:EmitSound("Hero_Disruptor.ThunderStrike.Target")
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, self.plasmaJumpRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

				local damage = {
					victim = enemy,
					attacker = caster,
					damage = self.plasmaJumpDamage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability
				}
				ApplyDamage( damage )
			end
		end
	end

	local leap_distance = (caster:GetAbsOrigin() - point):Length2D()
	local leap_range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)
	if leap_distance > leap_range then leap_distance = leap_range end

	-- Clears any current command
	caster:Stop()
	ability:StartCooldown(0.9)
	local start_position = GetGroundPosition(caster:GetAbsOrigin() , caster)
   
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())
	
	-- Physics
	local origin = caster:GetAbsOrigin()
	local direction = caster:GetForwardVector()
	local velocity = leap_distance / (0.9)
	local end_time = 0.9
	local time_elapsed = 0
	local jump = 48 + (leap_distance/96)
	local fall = jump / 15

	-- Move the unit
	Timers:CreateTimer(0, function()
		local ground_position = GetGroundPosition(caster:GetAbsOrigin() , caster)
		time_elapsed = time_elapsed + 0.03
		origin = caster:GetAbsOrigin()
		position = origin + direction * velocity / 30
		caster:SetAbsOrigin(position + Vector(0,0,jump))
		jump = jump - fall
		
		if time_elapsed > end_time then
			jump = jump * 1.1
			if caster:GetAbsOrigin().z - ground_position.z <= 0 then
				caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() , caster))
				FindClearSpaceForUnit(caster, origin, false)
				caster:RemoveModifierByName("modifier_plasma_leap")
				caster:EmitSound("Hero_Disruptor.ThunderStrike.Target")
				local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle2, 1, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle2, 2, caster:GetAbsOrigin())
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, self.plasmaJumpRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

							local damage = {
								victim = enemy,
								attacker = caster,
								damage = self.plasmaJumpDamage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								ability = ability
							}
							ApplyDamage( damage )
						end
					end
				end
				return nil
			end
		end
		if caster:GetAbsOrigin().z - ground_position.z <= 0 then
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() , caster))
		end
		return 0.03
	end)
end

function alpha_strider_plasma_leap_lua:CooldownSwap()
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