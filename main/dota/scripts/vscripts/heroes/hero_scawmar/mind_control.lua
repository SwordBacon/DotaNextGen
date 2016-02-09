function MindControlAdd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	enemyTeam = target:GetTeamNumber()
	friendlyPlayer = caster:GetPlayerID()
	enemyPlayer = target:GetPlayerID()

	target:SetTeam(15)
	target:SetOwner(caster)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_mind_control", {Duration = duration})
	target:SetControllableByPlayer(0, false)
	target:MoveToNPC(caster)

end

function MindControlThink( keys )
	local caster = keys.caster
	local target = keys.target

	target:MoveToNPC(caster)
end

function MindControlRemove( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target


	print("Removing Mind Control")
	target:SetTeam(enemyTeam)
	target:SetOwner(PlayerResource:GetPlayer( enemyPlayer ) )
	target:SetControllableByPlayer(enemyPlayer, true)

	caster:Stop()
end

function MindControlDamageCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	
	if damage == nil then damage = 0 end
	
	local threshold = ability:GetLevelSpecialValueFor("damage_threshold", ability:GetLevel() - 1)
	damage = damage + keys.DamageTaken
	
	if damage > threshold then
		target:RemoveModifierByName("modifier_mind_control")
		damage = 0
	end
	
end