function CheckMoves( keys )
	if not moveCount then moveCount = 0 end
	moveCount = moveCount + 1
	Timers:CreateTimer(2, function() 
		moveCount = moveCount - 1
	end)

	if moveCount < 3 then return end

	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability

	print(ability)
	print(target)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_block_commands", {})
end