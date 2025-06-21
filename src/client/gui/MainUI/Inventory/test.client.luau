--!strict

local GetDescendant = require(game.ReplicatedStorage.Shared.Utils.GetDescendant)

local player = game.Players.LocalPlayer :: Player
local InventoryModule = require(script.Parent.InventoryModule) :: any
local addBtn = GetDescendant(player, { "PlayerGui", "MainUI", "Inventory", "InventoryFrame", "AddBtn" }) :: TextButton
local removeBtn =
	GetDescendant(player, { "PlayerGui", "MainUI", "Inventory", "InventoryFrame", "RemoveBtn" }) :: TextButton
local inventory =
	InventoryModule.new(player, GetDescendant(player, { "PlayerGui", "MainUI", "Inventory", "InventoryFrame" }))

addBtn.MouseButton1Click:Connect(function()
	inventory:AddItem("sword")
end)

removeBtn.MouseButton1Click:Connect(function()
	local result = inventory:RemoveItem("sword")
	print(result)
end)
