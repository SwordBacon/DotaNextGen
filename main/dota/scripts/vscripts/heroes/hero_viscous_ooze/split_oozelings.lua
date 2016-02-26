function SplitOozelingsInitialize()
	oozeling_charges = 0
	damage_counter = 0
end

function SplitOozelingsCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.DamageTaken

	oozeling_charges = oozeling_charges or 0
	
	local max_charges = ability:GetLevelSpecialValueFor("max_charges", (ability:GetLevel() - 1))
	local threshold = ability:GetLevelSpecialValueFor("threshold", (ability:GetLevel() - 1))
	if damage_counter == nil then damage_counter = damage end
	damage_counter = damage_counter + damage

	while (damage_counter > threshold) do
		if oozeling_charges < max_charges then
			oozeling_charges = oozeling_charges + 1
			if not caster:HasModifier("modifier_split_oozelings_charges") then
				caster.ooze_stack = ParticleManager:CreateParticle("particles/viscous_ooze_oozeling_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
				ParticleManager:SetParticleControl(caster.ooze_stack, 1, Vector(0, 1, 0))
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_split_oozelings_charges", {})
			else
				ParticleManager:SetParticleControl(caster.ooze_stack, 1, Vector(0, oozeling_charges, 0))
				caster:SetModifierStackCount("modifier_split_oozelings_charges", ability, oozeling_charges)
			end
		end
		damage_counter = damage_counter - threshold
	end
end


function SplitOozelingsSpendCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	local health = caster:GetHealth()

	oozeCount = oozeling_charges
	oozeVector = caster:GetForwardVector()
	
	if caster:HasModifier("modifier_split_oozelings_charges") then
		caster:RemoveModifierByName("modifier_split_oozelings_charges")
	end


	repeat
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_split_oozelings_spend_charges", {})
		oozeling_charges = oozeling_charges - 1
		if caster:GetMaxHealth() > 150 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ooze_health_modifier", {Duration = 20})
			caster:SetModelScale(caster:GetModelScale() - 0.015)
		end
	until( oozeling_charges < 0 )

	if health > caster:GetHealth() then
		caster:SetHealth(health)
	end
	oozeling_charges = 0
end

function OozeGrow( keys )
	local caster = keys.caster

	caster:SetModelScale(caster:GetModelScale() + 0.015)
end

function LoseParticles( keys )
	local caster = keys.caster

	ParticleManager:DestroyParticle(caster.ooze_stack, true)
end

function GetSummonPoints( keys )
	local caster = keys.caster
	local ability = keys.ability
	local origin = caster:GetAbsOrigin()

	local vector = origin + oozeVector * 16
	local oozeAngle = 360 / (oozeCount + 1)

	local angle = QAngle(0, oozeAngle, 0)

	if not oozeAngle2 then oozeAngle2 = 0 end
	oozeAngle2 = oozeAngle2 + oozeAngle

	angle2 = QAngle(0, oozeAngle2, 0)
	point = RotatePosition(origin, angle2, vector)


	local result = { }
	table.insert(result, point)
	return result
end

function OozelingTracker( keys )
	local target = keys.target
	local ability = keys.ability
	
	local contact_radius = ability:GetLevelSpecialValueFor("contact_radius", (ability:GetLevel() - 1))
	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

	-- Find the valid units in the trigger radius
	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, contact_radius, target_team, target_types, target_flags, FIND_CLOSEST, false)

	if #units > 0 then
		Timers:CreateTimer(0.3, function()
			target:ForceKill(true)
		end)
	end
end

function OozelingAttack( keys )
	keys.attacker:ForceKill(true)
end

function OozelingDeath( keys )
	if not keys.target:IsAlive() then
		local particleName = "particles/viscous_ooze_toxic_ooze.vpcf"
		local soundEventName = "Ability.SandKing_CausticFinale"
		
		local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, keys.target )
		StartSoundEvent( soundEventName, keys.target )
	end
end