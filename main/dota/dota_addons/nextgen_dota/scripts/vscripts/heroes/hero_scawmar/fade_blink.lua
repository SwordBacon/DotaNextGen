function FadeBlinkSetPosition( keys )
	local caster = keys.caster
	point = keys.target_points[1]
end

function FadeBlinkActive( keys )
	local caster = keys.caster
	ProjectileManager:ProjectileDodge(caster)
	caster:AddNewModifier(caster, ability, "modifier_puck_phase_shift", {Duration = 0.05})
	FindClearSpaceForUnit(caster, point, false)
end

function ApplyInvisibility( keys )
	local caster = keys.caster
	local ability = keys.ability
	local invisTime = ability:GetLevelSpecialValueFor("fade_invis_time", ability:GetLevel() - 1)
	caster:AddNewModifier(caster, ability, "modifier_invisible", {Duration = invisTime})
end