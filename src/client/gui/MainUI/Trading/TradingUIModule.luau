--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules

-- Types
export type PlayerFrame = {
    label: TextLabel,
    -- id: number,
    button: TextButton
}

-- Local Variables
local PlayerFrame = ReplicatedStorage.Interfaces.Trading.PlayerFrame

-- Logic
local TradingUIModule = {}
TradingUIModule.__index = TradingUIModule

export type TradingUIModule = {
    -- Private Variables
    container: ScrollingFrame,
    playerFrames: { [string]: PlayerFrame },

    -- Methods
    AddPlayerToUI: (self: TradingUIModule, player: Player) -> (),
    RemovePlayerFromUI: (self: TradingUIModule, player: Player) -> (),
    AddExistingPlayersToUI: (self: TradingUIModule) -> (),
}

function TradingUIModule.new(container: ScrollingFrame): TradingUIModule
    local self = setmetatable({
        container = container,
        playerFrames = {},
    }, TradingUIModule) :: any
    return self
end

function TradingUIModule:AddPlayerToUI(player: Player)
    local playerName = player.DisplayName
    if player == game.Players.LocalPlayer or self.playerFrames[playerName] then return end

    local newPlayer = PlayerFrame:Clone()
    newPlayer.PlayerName.Text = playerName
    newPlayer.Name = playerName
    newPlayer.Parent = self.container

    self.playerFrames[playerName] = newPlayer

end

function TradingUIModule:RemovePlayerFromUI(player: Player)
    local playerName = player.DisplayName
    if not self.playerFrames[playerName] then return end

    local plrFrame = self.container:FindFirstChild(playerName)
    plrFrame:Destroy()

    self.playerFrames[playerName] = nil
end

function TradingUIModule:AddExistingPlayersToUI()

    for _, player in Players:GetPlayers() do
        self:AddPlayerToUI(player)
    end
end

return TradingUIModule