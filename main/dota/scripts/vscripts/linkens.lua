--[[ ============================================================================================================
	Author: Rook
	Date: January 30, 2015
	This function should be called from targeted datadriven abilities that can be blocked by Linken's Sphere.  
	Checks to see if the inputted unit has modifier_item_sphere_target on them.  If they do, the sphere is popped,
	the animation and sound plays, and true is returned.  If they do not, false is returned.
================================================================================================================= ]]
function RemoveLinkens( target )
	local target = target
	if target:HasModifier("modifier_item_sphere_target") then
		target:RemoveModifierByName("modifier_item_sphere_target")  --The particle effect is played automatically when this modifier is removed (but the sound isn't).
	elseif target:HasItemInInventory("item_sphere") then
		for i=0,5 do
			local item = target:GetItemInSlot(i)
			if item and target:GetItemInSlot(i):GetName() == "item_sphere" then
				item:StartCooldown(item:GetCooldown(-1))
			end
		end
	end
end
