function ShareTricks( keys )
	local caster = keys.caster
	local ability = keys.ability
	local player = caster:GetPlayerOwner()
	local pID = caster:GetPlayerOwnerID()

	for i=0, 4 do
		local ability = caster:GetAbilityByIndex(i)
		local ability_name = ability:GetName()
		local ability_level = ability:GetLevel()
		if ability_level > 0 then
			local item_name = "item_" .. ability_name
			local position = caster:GetAbsOrigin()
			local newItem = CreateItem( item_name, caster, caster )
			newItem:SetPurchaseTime( 0 )
			newItem:SetLevel(ability_level)
			local drop = CreateItemOnPositionSync( position , newItem)
			if drop then
				drop:SetContainedItem( newItem )
				newItem:LaunchLoot( false, 200, 0.35, position + RandomVector( RandomFloat( 30, 300 ) ) )
				Timers:CreateTimer(60, function()
					newItem:Kill()
					drop:Kill()
				end)
			end
		end
	end
end
