function StealBounty( keys )
	local caster = keys.caster
	local target = keys.unit
	local attacker = keys.attacker
	local ability = keys.ability
	local Damage = keys.Damage
	
	if attacker:HasModifier("modifier_poverty") 
	and Damage > target:GetHealth() then
		target:SetTeam(attacker:GetTeam())
		ability:ApplyDataDrivenModifier(caster, target, "modifier_poverty_remove", {duration = 0.1})
		target:Kill(ability, caster)
		attacker:StopSound("Hero_Silencer.LastWord.Target")
		attacker:RemoveModifierByName("modifier_poverty")
		attacker:RemoveModifierByName("modifier_poverty_debuff")
		
	end
end

function LoseGold( keys )
	local caster = keys.caster
	local target = keys.target
	local tpid = target:GetPlayerID()

	local ability = keys.ability
	local goldPercent = ability:GetLevelSpecialValueFor("gold_loss_pct", ability:GetLevel() - 1)/100.0

	local gold = PlayerResource:GetGold(tpid)
	local goldLoss = target:GetDeathGoldCost() * goldPercent
	print(gold)
	print(goldLoss)
	local goldDifference = (gold - goldLoss) - PlayerResource:GetReliableGold(tpid)

	PlayerResource:SetGold(tpid, goldDifference, false)
end

function StackableSlow( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local stackCount = target:GetModifierStackCount("modifier_poverty_slow", ability)
	if stackCount == 0 then stackCount = 1 end
	print(stackCount)

	target:SetModifierStackCount("modifier_poverty_slow", ability, stackCount + 1)
end