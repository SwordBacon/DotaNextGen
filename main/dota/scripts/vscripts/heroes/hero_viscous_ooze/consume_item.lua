function ConsumeItemGainCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	local charges = caster:GetModifierStackCount("modifier_consume_item_charges", caster) + 2
	if not caster:HasModifier("modifier_consume_item_charges") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_consume_item_charges", {})
	end
	caster:SetModifierStackCount("modifier_consume_item_charges", ability, charges)
end

function ConsumeItemOn( keys )
	local caster = keys.caster
	local ability = keys.ability
	local player = caster:GetPlayerOwner()
	local pID = caster:GetPlayerOwnerID()

	owner = {}
	
	for i=0, 5 do
		local item = caster:GetItemInSlot(i)
	
		if item == nil then	
			caster:AddItem(CreateItem("item_dummy_datadriven", caster, caster))
		else
			owner[i] = item:GetPurchaser()
			local item_name = item:GetName()
			local consume_item_name = item_name .. "_datadriven"
			if item:IsPermanent() and item_name ~= "item_aegis" then
				local item_charges = item:GetCurrentCharges()
				local item_level = item:GetLevel()
				caster:RemoveItem(item)
				caster:AddItem(CreateItem(consume_item_name, owner[i], owner[i]))
				local checkitem = caster:GetItemInSlot(i)
				if checkitem == nil then
					caster:AddItem(CreateItem(item_name, owner[i], owner[i]))
					checkitem = caster:GetItemInSlot(i)
				end
				checkitem:SetCurrentCharges(item_charges)
				checkitem:SetLevel(item_level)
				print(item_level)
			end
		end
	end
	for j=0, 5 do
		local temp_item = caster:GetItemInSlot(j)
		local temp_item_name = temp_item:GetName()
		if temp_item_name == "item_dummy_datadriven" then
			caster:RemoveItem(temp_item)
		end
	end
end

function ConsumeItemOff( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	for i=0, 5 do
		local item = caster:GetItemInSlot(i)
		
		if item == nil then	
			caster:AddItem(CreateItem("item_dummy_datadriven", caster, caster))
		else 
			owner[i] = item:GetPurchaser()
			local item_name = item:GetName()
			local item_charges = item:GetCurrentCharges()
			local item_level = item:GetLevel()
			if item:IsPermanent() and item:GetName() ~= "item_aegis" then
				caster:RemoveItem(item)
				item_name = item_name:gsub("_datadriven", "")
				caster:AddItem(CreateItem(item_name, owner[i], owner[i]))
				local checkitem = caster:GetItemInSlot(i)
				checkitem:SetCurrentCharges(item_charges)
				checkitem:SetLevel(item_level)
			end
		end
	end
	for j=0, 5 do
		local temp_item = caster:GetItemInSlot(j)
		local temp_item_name = temp_item:GetName()
		if temp_item_name == "item_dummy_datadriven" then
			caster:RemoveItem(temp_item)
		end
	end
end
