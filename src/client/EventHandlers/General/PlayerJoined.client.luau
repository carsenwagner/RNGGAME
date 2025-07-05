--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

-- Modules
local TradingUI = require(StarterPlayer.StarterPlayerScripts.Client.Services.TradingUiService)

-- Remote Events
local PlayerJoinedEvent: RemoteEvent = ReplicatedStorage.Remotes.General.PlayerJoined

-- Logic
PlayerJoinedEvent.OnClientEvent:Connect(function(player: Player)
    TradingUI:AddPlayerToUI(player)
end)