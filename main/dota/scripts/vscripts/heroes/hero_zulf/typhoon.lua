function TyphoonSpinEffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if target:IsMagicImmune() or target:HasModifier("modifier_roshan_bash") then return end
	
	-- calculates rotation
	local origin = caster:GetAbsOrigin()
	local distance = target:GetAbsOrigin() - caster:GetAbsOrigin()
	local distanceLength = distance:Length2D()
	local randomSpeed = (RandomInt(5,20) * 60) / distanceLength

	-- Scepter Upgrade - Increases velocity by 50%
	if caster:HasScepter() then randomSpeed = randomSpeed * 1.5 end

	local increaseSpeed = randomSpeed / 10
	local variableSpeed = increaseSpeed
	
	
	-- calculates elevation
	local jump = RandomInt(12,18)/10.0

	-- Scepter Upgrade - Increases lift by 50%
	if caster:HasScepter() then jump = jump * 1.5 end

	local gravity = 0.5
	
	-- Scepter Upgrade - Increases lift by 50%
	if caster:HasScepter() then gravity = gravity * 1.5 end

	local height = 0
	
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local damageElevation = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 ) / 100.0
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_typhoon_stunned", {})
	ability:CreateVisibilityNode(caster:GetAbsOrigin(), radius, duration)
	target:EmitSound("n_creep_Wildkin.Tornado")

	Timers:CreateTimer(0, function()
		local ground_position = GetGroundPosition(target:GetAbsOrigin() , target)
		local height = height + jump
		local origin = caster:GetAbsOrigin()
		local distance = target:GetAbsOrigin() - origin
		local vector = distance:Normalized()
		local newDistanceLength = distance:Length()
		local rotate_position = origin + vector * newDistanceLength
		local rotate_angle = QAngle(0, randomSpeed, 0)
		local rotate_point = RotatePosition(origin, rotate_angle, rotate_position)
		local randomDistance = newDistanceLength + increaseSpeed

		if caster:HasModifier("modifier_typhoon") then
			jump = jump + (gravity / 5)
			target:SetAbsOrigin(rotate_point + Vector(0,0,jump) )
			target.fallDamage = target:GetAbsOrigin().z
			randomSpeed = randomSpeed + variableSpeed
			variableSpeed = variableSpeed / 1.03
		else
			target:StopSound("n_creep_Wildkin.Tornado")
			jump = jump - (gravity * 3)
			randomDistance = randomDistance + 12
			rotate_position = origin + vector * randomDistance
			rotate_point = RotatePosition(origin, rotate_angle, rotate_position)
			target:SetAbsOrigin(rotate_point + Vector(0,0,jump) )
			if randomSpeed >= increaseSpeed then
				randomSpeed = randomSpeed - increaseSpeed
			else
				randomSpeed = 0
			end
		end
		if target:GetAbsOrigin().z - ground_position.z <= 0 and not caster:HasModifier("modifier_typhoon") then 
			target:RemoveModifierByName("modifier_typhoon_stunned")
			target:SetAbsOrigin(ground_position)
			FindClearSpaceForUnit(target, target:GetAbsOrigin(), false) 
			
			local damageTable = {}

				damageTable.attacker = caster
				damageTable.victim = target
				damageTable.damage_type = ability:GetAbilityDamageType()
				damageTable.ability = ability
				damageTable.damage = target.fallDamage  * damageElevation
	
			ApplyDamage(damageTable)

			local amount = target.fallDamage * damageElevation

	        local armor = target:GetPhysicalArmorValue()
	        local damageReduction = ((0.02 * armor) / (1 + 0.02 * armor))
	        amount = amount - (amount * damageReduction)

		    local lens_count = 0
		    for i=0,5 do
		        local item = caster:GetItemInSlot(i)
		        if item ~= nil and item:GetName() == "item_aether_lens" then
		            lens_count = lens_count + 1
		        end
		    end
		    amount = amount * (1 + (.08 * lens_count))

    		amount = math.floor(amount)

    		PopupNumbers(target, "damage", Vector(255, 26, 26), 2.0, amount, nil, POPUP_SYMBOL_POST_DROP)

			return nil
		end
		return 1/30
	end)
end

function RemoveSound( keys )
	keys.caster:StopSound("Ability.Windrun")
end