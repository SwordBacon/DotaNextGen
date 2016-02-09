function LevelUpAbility( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = event.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end

function SwapVicissitude( keys )
	local caster = keys.caster
	local ability = keys.ability

	caster:SwapAbilities("suna_vicissitude", "suna_mind_control", false, true)
	caster:AddNoDraw()
	caster:Stop()

end

function SwapMindControl( keys )
	local caster = keys.caster
	local ability = keys.ability

	caster:SwapAbilities("suna_mind_control", "suna_vicissitude", false, true)
	caster:RemoveNoDraw()
end

function MindControlCheckCooldown( keys )
	local caster = keys.caster
	local ability = keys.ability
end

function MindControlAdd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	caster:RemoveNoDraw()
	enemyTeam = target:GetTeamNumber()
	friendlyPlayer = caster:GetPlayerID()
	enemyPlayer = target:GetPlayerID()

	ability:ApplyDataDrivenModifier(caster, target, "modifier_vicissitude", {Duration = duration})
	target:SetControllableByPlayer(friendlyPlayer, false)
	target:SetOwner(caster)
	target:SetTeam(15)
end

function MindControlRemove( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	target:SetTeam(enemyTeam)
	if enemyPlayer then 
		target:SetControllableByPlayer(enemyPlayer, false)
		target:SetOwner(PlayerResource:GetPlayer( enemyPlayer ) )
	else
		target:SetControllableByPlayer(0, false)
		target:SetOwner(PlayerResource:GetPlayer( enemyPlayer ) )
	end
end

function MindControlKill( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = targetMC
	local damage = keys.Damage

	if damage >= target:GetHealth() and not target:HasModifier("modifier_shallow_grave") then
		target:Kill(ability, caster)
	end

end

function MindControlDie( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = keys.Damage

	if damage >= target:GetHealth() and not target:HasModifier("modifier_shallow_grave") then
		target:Kill(ability, caster)
	end
end

function SetBurrowLocation( keys )
	local caster = keys.caster
	local target = keys.target

	if caster:HasModifier("modifier_vicissitude_burrow") then
		target:SetAbsOrigin(caster:GetAbsOrigin())
	else
		target:ForceKill(false)
	end
end
