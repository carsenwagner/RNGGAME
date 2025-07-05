--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

-- Modules
local GetDescendant = require(ReplicatedStorage.Shared.Utils.GetDescendant)
local TradingUIModule = require(StarterPlayer.StarterPlayerScripts.Client.gui.MainUI.Trading.TradingUIModule)

-- Local Variables
local localPlayer = game.Players.LocalPlayer

-- Logic
local TradingUIInstance = TradingUIModule.new(GetDescendant(localPlayer, { "PlayerGui", "MainUI", "Trading", "TradingFrame", "PlayersFrame"}) :: ScrollingFrame)
TradingUIInstance:AddExistingPlayersToUI()

return TradingUIInstance
