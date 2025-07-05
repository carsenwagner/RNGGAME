--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local GetDescendant = require(ReplicatedStorage.Shared.Utils.GetDescendant)

-- Types
type InventorySlot = {
	Frame: Frame,
	Amount: IntValue,
}

-- Logic
local InventoryModule = {}
InventoryModule.__index = InventoryModule

export type InventoryModule = {
	container: Frame,
	slots: { [string]: InventorySlot },
	player: Player,

	AddItem: (self: InventoryModule, itemName: string, count: number?) -> (),
	RemoveItem: (self: InventoryModule, itemName: string, count: number?) -> (),
	DeleteSlot: (self: InventoryModule, itemName: string) -> (),
	UpdateInventory: (self: InventoryModule, inventoryData: { [string]: number }) -> (),
}

local function AddSlot(self: InventoryModule, itemName: string, count: number?): { [string]: InventorySlot }
	local protectedCount: number = count or 1
	local newSlot = GetDescendant(self.player, { "PlayerGui", "MainUI", "Inventory", "SlotTemplate" }):Clone() :: Frame

	newSlot.Name = itemName
	newSlot.Visible = true
	newSlot.Parent = self.container

	local amount = newSlot:WaitForChild("Amount") :: IntValue
	amount.Value = protectedCount

	self.slots[itemName] = {
		Frame = newSlot,
		Amount = amount,
	}
	return self.slots
end

function InventoryModule.new(container: Frame): InventoryModule
	local self = setmetatable({
		container = container,
		slots = {},
		player = game.Players.LocalPlayer,
	}, InventoryModule) :: any
	return self
end

function InventoryModule:AddItem(itemName: string, count: number?)
	local slot: InventorySlot = self.slots[itemName]
	if slot then
		slot.Amount.Value += 1
	else
		self.slots = AddSlot(self, itemName, count)
	end
end

function InventoryModule:RemoveItem(itemName: string, count: number?)
	local protectedCount = count or 1
	local slot: InventorySlot = self.slots[itemName]
	if slot then
		slot.Amount.Value = protectedCount
	end
end

function InventoryModule:DeleteSlot(itemName: string)
	local slot: InventorySlot = self.slots[itemName]
	if slot then
		slot.Frame:Destroy()
		self.slots[itemName] = nil
	end
end

function InventoryModule:UpdateInventory(inventoryData: { [string]: number })
	for itemName, count in pairs(inventoryData) do
		if not next(self.slots) or self.slots[itemName].Amount.value < count then 
			self:AddItem(itemName, count)
			continue 
		end

		if count == 0 then
			self:DeleteSlot(itemName) 
			continue
		end

		if self.slots[itemName].Amount.Value > count then
			self:RemoveItem(itemName, count)
			continue
		end
	end
end

return InventoryModule