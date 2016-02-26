if arbalest == nil then
	arbalest = class({})
end
LinkLuaModifier( "arbalest_attack_dummy", "heroes/skoros/modifiers/arbalest_attack_dummy.lua" ,LUA_MODIFIER_MOTION_NONE )

function SwapSpells (keys)
	local caster = keys.caster
	caster.spellowner = caster
	local ability = keys.ability
	mainability = ability:GetAbilityName()
	sub_ability_name = keys.sub_ability_name
	caster.spellowner:AddNewModifier(spellowner, ability, "arbalest_attack_dummy", {duration = ability:GetDuration()})
	caster.spellowner:SwapAbilities(mainability, sub_ability_name, false, true)
end

function SwapSpellsBack (keys)
	local caster = keys.target
	caster.spellowner:Stop()
	caster.spellowner:SwapAbilities(mainability, sub_ability_name, true, false)
end

function projectilehit (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local vision = ability:GetSpecialValueFor("target_vision_radius")
	local duration = ability:GetSpecialValueFor("target_vision_duration")

	if target:IsCreep() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arbalest_creep", {})
	end

	caster:PerformAttack( target, true, true, true, false, false )
	AddFOWViewer(caster:GetTeamNumber(),target:GetAbsOrigin(), vision , duration, true)
	caster:RemoveModifierByName("modifier_arbalest_creep")
end

function DONTATTACK (keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("skoros_Arbalest_Attack")
	local target = keys.target
	local modifier = caster:FindModifierByName("skoros_Arbalest")
	print(ability:GetName())
	caster:Stop()
	if IsValidEntity(caster) and ability:IsFullyCastable() then
		caster:CastAbilityOnPosition(target:GetAbsOrigin(), ability, caster:GetPlayerID())
	end
end

function CheckCastPoint (keys)
	local caster = keys.caster
	local ability = keys.ability
	local attackSpeed = (caster:GetSecondsPerAttack() + 0.5) / 2
	print(attackSpeed)
end
