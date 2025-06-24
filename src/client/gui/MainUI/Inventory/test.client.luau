--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local GetDescendant = require(ReplicatedStorage.Shared.Utils.GetDescendant)

-- Local Variables
local player = game.Players.LocalPlayer :: Player
local addBtn = GetDescendant(player, { "PlayerGui", "MainUI", "Inventory", "InventoryFrame", "AddBtn" }) :: TextButton
local removeBtn =
	GetDescendant(player, { "PlayerGui", "MainUI", "Inventory", "InventoryFrame", "RemoveBtn" }) :: TextButton

-- Events
local AddItemEvent: RemoteEvent = ReplicatedStorage.Remotes.Inventory.Events.AddItem
local RemoveItemEvent: RemoteEvent = ReplicatedStorage.Remotes.Inventory.Events.RemoveItem

-- Logic
addBtn.MouseButton1Click:Connect(function()
	AddItemEvent:FireServer("Sword", 1)
end)

removeBtn.MouseButton1Click:Connect(function()
	RemoveItemEvent:FireServer("Sword", 1)
end)
