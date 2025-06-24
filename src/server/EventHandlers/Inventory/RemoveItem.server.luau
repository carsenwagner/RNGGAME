--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules
local InventoryService = require(ServerScriptService.Server.Services.InventoryServices)

-- Events
local RemoveItemEvent: RemoteEvent = ReplicatedStorage.Remotes.Inventory.Events.RemoveItem
local UpdateInventoryEvent: RemoteEvent = ReplicatedStorage.Remotes.Inventory.Events.UpdateInventory

-- Logic
RemoveItemEvent.OnServerEvent:Connect(function(player: Player, itemName: string, amount: number?)
	amount = amount or 1
	local inventory = InventoryService.get(player)

	if not inventory then
		return
	end

	if typeof(itemName) ~= "string" or typeof(amount) ~= "number" then
		return
	end

	if not (amount >= 1) then
		return
	end

	inventory:RemoveItem(itemName, amount)
	UpdateInventoryEvent:FireClient(player, inventory:GetAllItems())
	print(inventory)
end)
