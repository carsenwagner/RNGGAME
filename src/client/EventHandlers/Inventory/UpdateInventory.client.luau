--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

-- Modules
local InventoryModule = require(StarterPlayer.StarterPlayerScripts.Client.gui.MainUI.Inventory.InventoryModule)
local GetDescendant = require(ReplicatedStorage.Shared.Utils.GetDescendant)

-- Local Variables
local player = game.Players.LocalPlayer
local inventoryUi = InventoryModule.new(
	GetDescendant(player, { "PlayerGui", "MainUI", "Inventory", "InventoryFrame", "SlotsFrame" }) :: Frame
)

-- Events
local UpdateInventoryEvent: RemoteEvent = ReplicatedStorage.Remotes.Events.Inventory.UpdateInventory

-- Logic
UpdateInventoryEvent.OnClientEvent:Connect(function(data: { [string]: number })
	inventoryUi:UpdateInventory(data)
end)
