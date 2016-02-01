function ConsumeItemSpendCharge( keys )
	local caster = keys.caster
	local item = keys.ability

	local item_name = item:GetName():gsub("_datadriven", "")
	local item_value = GetItemCost(item_name)
	local modifier_name = "modifier_" .. item_name
	print(item_value)
	print(modifier_name)

	caster:RemoveItem(item)
	
	local ability = caster:FindAbilityByName("viscous_ooze_consume_item")
	local gold_cooldown = (item_value * ability:GetLevelSpecialValueFor("gold_cooldown", ability:GetLevel() - 1)) / 10
	local total_cooldown = ability:GetLevelSpecialValueFor("base_cooldown", ability:GetLevel() - 1) + gold_cooldown

	print(gold_cooldown)
	print(total_cooldown)


	ability:ToggleAbility()
	ability:StartCooldown(total_cooldown)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_consume_item_look", {})

	local time = 300
	local counter = 5
	local interval = time / counter
	local player = PlayerResource:GetPlayer( caster:GetPlayerID() )
	local playerID = caster:GetPlayerOwnerID()

	Timers:CreateTimer(interval, function ()
		counter = counter - 1
		value = item_value / 5
		caster:ModifyGold(value, false, 0)
		EmitSoundOnClient("General.Coins", PlayerResource:GetPlayer(playerID))	
		EmitSoundOnClient("DOTA_Item.Hand_Of_Midas.Activate", PlayerResource:GetPlayer(playerID))	

		

		local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"		
		local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, caster, player )
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )

		local symbol = 0 -- "+" presymbol
		local color = Vector(255, 200, 33) -- Gold
		local lifetime = 2.5
		local digits = string.len(value) + 1
		local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
		local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, caster, player )
		ParticleManager:SetParticleControl( particle, 1, Vector( symbol, value, symbol) )
	    ParticleManager:SetParticleControl( particle, 2, Vector( lifetime, digits, 0) )
	    ParticleManager:SetParticleControl( particle, 3, color )

		if counter < 1 then return nil else return interval end
	end)
end