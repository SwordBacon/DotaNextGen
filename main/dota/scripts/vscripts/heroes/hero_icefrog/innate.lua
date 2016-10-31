function MakeClone( keys )
	local caster = keys.caster
	local ability = keys.ability

	Timers:CreateTimer(1, function ()
		local clone = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin(), true, nil, nil, caster:GetTeamNumber())
		clone:AddNewModifier(caster, ability, "modifier_super_illusion", {duration = -1})
		clone:SetOwner(caster)
		clone:SetControllableByPlayer(caster:GetPlayerID(), false)
		clone:MakeIllusion()
		local innate = clone:FindAbilityByName("icefrog_innate")
		innate:SetLevel(1)
		clone:SetAbilityPoints(0)
	end)
end