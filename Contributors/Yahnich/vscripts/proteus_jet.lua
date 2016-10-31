function Jet( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	-- Distance calculations
	if caster:PassivesDisabled() then return end
	local speed = ability:GetSpecialValueFor("jet_speed")
	local distance =  ability:GetSpecialValueFor("jet_distance")
	local direction = caster:GetForwardVector()

	-- Saving the data in the ability
	ability.distance = distance
	
	ability.speed = speed / 30 -- 1/30 is how often the motion controller ticks
	ability.direction = direction
	ability.traveled_distance = 0
	ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = 2})
end

function JetMotion(keys)
	local caster = keys.caster
	local ability = keys.ability
	-- Move the caster while the distance traveled is less than the original distance upon cast
	local original_position = caster:GetAbsOrigin()
	if ability.traveled_distance < ability.distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.direction * ability.speed)
		ability.traveled_distance = ability.traveled_distance + ability.speed
		particle_jet = ParticleManager:CreateParticle("particles/proteus_jet_trail.vpcf", PATTACH_ABSORIGIN, caster)
	else
		-- Remove the motion controller once the distance has been traveled
		caster:InterruptMotionControllers(true)
		caster:RemoveModifierByName("modifier_proteus_jet_push")
	end
end

function JetSilenced(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:IsSilenced() and caster:GetMana() > ability:GetManaCost(-1) and ability:GetAutoCastState() then
		ability:OnSpellStart()
		caster:SpendMana(ability:GetManaCost(-1))
		ability:StartCooldown(ability:GetCooldown(-1))
	end
end