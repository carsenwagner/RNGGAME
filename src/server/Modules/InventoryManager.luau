--!strict

-- Logic
local InventoryManager = {}
InventoryManager.__index = InventoryManager

export type InventoryManager = {
	items: { [string]: number },
	player: Player,
	AddItem: (self: InventoryManager, item: string, amount: number?) -> (),
	RemoveItem: (self: InventoryManager, item: string, amount: number?) -> (),
	GetItemCount: (self: InventoryManager, item: string) -> number,
	GetAllItems: (self: InventoryManager) -> { [string]: number },
}

function InventoryManager.new(player: Player): InventoryManager
	local self = setmetatable({
		items = {},
		player = player,
	}, InventoryManager) :: any
	return self
end

function InventoryManager:AddItem(item: string, amount: number?)
	local amt: number = amount or 1
	self.items[item] = (self.items[item] or 0) :: number + amt
end

function InventoryManager:RemoveItem(item: string, amount: number?)
	local amt: number = amount or 1
	if (self.items[item] or 0) >= amt then
		self.items[item] = self.items[item] - amt
	end
end

function InventoryManager:GetItemCount(item: string): number
	return self.items[item]
end

function InventoryManager:GetAllItems(): { [string]: number }
	return self.items
end

return InventoryManager
