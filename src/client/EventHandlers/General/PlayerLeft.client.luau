--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

-- Modules
local TradingUI = require(StarterPlayer.StarterPlayerScripts.Client.Services.TradingUiService)

-- Remote Events
local PlayerLeftEvent: RemoteEvent = ReplicatedStorage.Remotes.General.PlayerLeft

-- Logic
PlayerLeftEvent.OnClientEvent:Connect(function(player: Player)
    TradingUI:RemovePlayerFromUI(player)
end)