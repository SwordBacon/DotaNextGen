function ExperienceGain( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local XPamount = ability:GetSpecialValueFor("experience_gain")
	local healPercent = ability:GetSpecialValueFor("heal_percent") / 100

	target:AddExperience(XPamount, 0, false, false)
	target:Heal(target:GetMaxHealth() * healPercent, ability)
end

function Initiate(keys)
	keys.caster.assistsAndKills = 0
end

function CheckCooldown( keys )
	local caster = keys.caster
	local assistsAndKills = caster:GetAssists() + caster:GetKills()

	--Reducing cooldown if caster assists/kills raises
	while assistsAndKills ~= caster.assistsAndKills do
		local ability = keys.ability
		local cooldownReduction = ability:GetSpecialValueFor("cooldown_reduction")
		local cooldown = ability:GetCooldownTimeRemaining() - cooldownReduction
		ability:EndCooldown()
		if cooldown > 0 then
			ability:StartCooldown(cooldown)
		end
		caster.assistsAndKills = caster.assistsAndKills + 1
	end
end