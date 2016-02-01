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
	target:SetTeam(caster:GetTeam())
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
function BuildDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = keys.Damage

	if not total_damage then total_damage = 0 end
	total_damage = total_damage + damage
end

function AddNoDraw( keys )
	local caster = keys.caster

	caster:AddNoDraw()
end

function RemoveNoDraw( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damageType = ability:GetAbilityDamageType()

	caster:RemoveNoDraw()
	ApplyDamage({ victim = caster, attacker = target, ability = ability:GetName(), damage = total_damage, damage_type = damageType })
	total_damage = 0 
end