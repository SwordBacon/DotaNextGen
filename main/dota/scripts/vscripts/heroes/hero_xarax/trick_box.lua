function TrickBoxSetTimer( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if target:TriggerSpellAbsorb(ability) then
		RemoveLinkens(target)
		return
	end
	
	local modifier = keys.modifier
	
	local min_duration = ability:GetLevelSpecialValueFor("min_delay", ability:GetLevel() - 1 )
	local max_duration = ability:GetLevelSpecialValueFor("max_delay", ability:GetLevel() - 1 )
	
	local random_duration = math.random(min_duration, max_duration)
	
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

	local counter = math.random(22)
	local meme = "modifier_trick_3_meme_" .. counter
	
	ability:ApplyDataDrivenModifier(caster, target, meme, {})
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

function FeelsBadMan( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability

	if unit then
		local location = unit:GetAbsOrigin()
		local dummy = CreateUnitByName("dummy_unit", location, false, caster, caster:GetPlayerOwner(), caster:GetTeamNumber())
		dummy:AddNewModifier(caster,nil,"modifier_kill",{Duration = 20})
		dummy:EmitSound("Hero_Xarax.Trick.FeelsBadMan")
		ability:ApplyDataDrivenModifier(caster,dummy,"modifier_trick_3_meme_8_feelsbadman",{})
	end
end

function FeelsMLGMan( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability

	if unit then
		local location = unit:GetAbsOrigin()
		local dummy = CreateUnitByName("dummy_unit", location, false, caster, caster:GetPlayerOwner(), caster:GetTeamNumber())
		dummy:AddNewModifier(caster,nil,"modifier_kill",{Duration = 20})
		dummy:EmitSound("Hero_Xarax.Trick.FeelsMLGMan")
		ability:ApplyDataDrivenModifier(caster,dummy,"modifier_trick_3_meme_21_feelsmlgman",{})
	end
end

function FamiliarFaces( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability

	if unit then
		local location = unit:GetAbsOrigin()
		local dummy = CreateUnitByName("dummy_unit", location, false, caster, caster:GetPlayerOwner(), caster:GetTeamNumber())
		dummy:AddNewModifier(caster,nil,"modifier_kill",{Duration = 4.5})
		dummy:EmitSound("Hero_Xarax.Trick.FamiliarFaces")
		ability:ApplyDataDrivenModifier(caster,dummy,"modifier_trick_3_meme_15_familiarfaces",{})
	end
end



function YouHaveToSayThatYoureFineButYoureNotReallyFine( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability

	if unit then
		local location = unit:GetAbsOrigin()
		local dummy = CreateUnitByName("dummy_unit", location, false, caster, caster:GetPlayerOwner(), caster:GetTeamNumber())
		dummy:AddNewModifier(caster,nil,"modifier_kill",{Duration = 6})
		dummy:EmitSound("Hero_Xarax.Trick.YouHaveToSayThatYoureFineButYoureNotReallyFine")
		ability:ApplyDataDrivenModifier(caster,dummy,"modifier_trick_3_meme_22_YouHaveToSayThatYoureFineButYoureNotReallyFine",{})
	end
end

function RemoveMusic( keys )
	local target = keys.target

	target:StopSound("Hero_Xarax.Trick.Confirmed")
	target:StopSound("Hero_Xarax.Trick.Lie")
	target:StopSound("Hero_Xarax.Trick.Electric")
	target:StopSound("Hero_Xarax.Trick.TopPlays")
	target:StopSound("Hero_Xarax.Trick.MangoBay")
	target:StopSound("Hero_Xarax.Trick.BTSIntro")
	target:StopSound("Hero_Xarax.Trick.AttackOnTitan")
	target:StopSound("Hero_Xarax.Trick.ILOVESLAYER")
	target:StopSound("Hero_Xarax.Trick.JUSTDOIT")
end