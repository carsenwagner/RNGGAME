--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules
local InventoryService = require(ServerScriptService.Server.Services.InventoryServices)

-- Events
local AddItemEvent: RemoteEvent = ReplicatedStorage.Remotes.Inventory.Events.ClientToServer.AddItem
local UpdateInventoryEvent: RemoteEvent = ReplicatedStorage.Remotes.Inventory.Events.ServerToClient.UpdateInventory

-- Logic
AddItemEvent.OnServerEvent:Connect(function(player: Player, itemName: string, amount: number?)
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

	inventory:AddItem(itemName, amount)
	UpdateInventoryEvent:FireClient(player, inventory:GetAllItems())
	print(inventory)
end)
