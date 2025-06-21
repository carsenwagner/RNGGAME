--!strict

local GetDescendant = require(game.ReplicatedStorage.Shared.Utils.GetDescendant)

type InventorySlot = {
	Frame: Frame,
	Amount: IntValue,
}

local InventoryModule = {}
InventoryModule.__index = InventoryModule

export type InventoryModule = {
	player: Player,
	container: Frame,
	slots: { [string]: InventorySlot },

	AddItem: (self: InventoryModule, itemName: string) -> (),
	RemoveItem: (self: InventoryModule, itemName: string) -> boolean,
}

function InventoryModule.new(player: Player, container: Frame): InventoryModule
	local self = setmetatable({
		player = player,
		container = container,
		slots = {},
	}, InventoryModule) :: any
	return self
end

function InventoryModule:AddItem(itemName: string)
	if self.slots[itemName] then
		local slot: InventorySlot = self.slots[itemName]
		slot.Amount.Value += 1
	else
		local newSlot =
			GetDescendant(self.player, { "PlayerGui", "MainUI", "Inventory", "SlotTemplate" }):Clone() :: Frame

		newSlot.Name = itemName
		newSlot.Visible = true
		newSlot.Parent = self.container

		local amount = newSlot:WaitForChild("Amount") :: IntValue
		amount.Value = 1

		self.slots[itemName] = {
			Frame = newSlot,
			Amount = amount,
		}
	end
end

function InventoryModule:RemoveItem(itemName: string): boolean
	local slot = self.slots[itemName]
	if slot then
		slot.Frame:Destroy()
		self.slots[itemName] = nil
		return true
	end
	return false
end

return InventoryModule
