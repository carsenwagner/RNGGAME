--!strict

-- Services
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules
local InventoryManager = require(ServerScriptService.Server.Modules.InventoryManager)

-- Logic
local InventoryServices = {}
local inventories = {} :: { [Player]: InventoryManager.InventoryManager }

function InventoryServices.Init()
	local Players: Players = game:GetService("Players")

	Players.PlayerAdded:Connect(function(player: Player)
		inventories[player] = InventoryManager.new(player)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		inventories[player] = nil
	end)
end

function InventoryServices.get(player: Player): InventoryManager.InventoryManager?
	return inventories[player]
end

return InventoryServices
