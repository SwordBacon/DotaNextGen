function GameMode:FilterDamage( filterTable )

	local attackerIndex = filterTable["entindex_attacker_const"]
	local attacker = EntIndexToHScript(attackerIndex)
	local victimIndex = filterTable["entindex_victim_const"]
	local victim = EntIndexToHScript(victimIndex)
	local damageType = filterTable["damagetype_const"]
	local damage = filterTable["damage"]

	if attacker:HasModifier("modifier_argent_smite") and victim:HasModifier("modifier_specially_deniable") and damageType == 1 then
		filterTable["damage"] = 0
	end
	return true

end
