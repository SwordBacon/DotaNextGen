function TrickBoxSetTimer( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	
	local min_duration = ability:GetLevelSpecialValueFor("min_delay", ability:GetLevel() - 1 )
	local max_duration = ability:GetLevelSpecialValueFor("max_delay", ability:GetLevel() - 1 )
	
	local random_duration = math.random(min_duration, max_duration)
	print(random_duration)
	
	ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = random_duration})
end

function TrickBox1Activate( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local counter = math.random(3)
	
	if counter == 1 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_1_slow", {})
	elseif counter == 2 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_1_stun", {})
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_1_silence", {})
	end
end

function TrickBox2Activate( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local counter = math.random(3)
	
	if counter == 1 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_2_instant_damage", {Duration = 0.1})
	elseif counter == 2 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_2_damage_over_time", {})
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_2_splash_damage", {Duration = 0.1})
	end
end

function TrickBox3Activate( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local counter = math.random(3)
	
	if counter == 1 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_3_error", {})
	elseif counter == 2 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_3_confirmed", {})
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_trick_3_lie", {})
	end
end

function LevelUpAbility( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name_1 = event.ability_name_1
	local ability_handle_1 = caster:FindAbilityByName(ability_name_1)	
	local ability_level_1 = ability_handle_1:GetLevel()

	-- Check to not enter a level up loop
	if ability_level_1 ~= this_abilityLevel then
		ability_handle_1:SetLevel(this_abilityLevel)
	end
	
	local ability_name_2 = event.ability_name_2
	local ability_handle_2 = caster:FindAbilityByName(ability_name_2)	
	local ability_level_2 = ability_handle_2:GetLevel()

	-- Check to not enter a level up loop
	if ability_level_2 ~= this_abilityLevel then
		ability_handle_2:SetLevel(this_abilityLevel)
	end
end

function RemoveMusic( keys )
	local target = keys.target

	target:StopSound("Hero_Xarax.Trick.Confirmed")
	target:StopSound("Hero_Xarax.Trick.Lie")

end