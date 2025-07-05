--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvents
local PlayerJoinedEvent: RemoteEvent = ReplicatedStorage.Remotes.General.Events.ServerToClient.PlayerJoined
local PlayerLeftEvent: RemoteEvent = ReplicatedStorage.Remotes.General.Events.ServerToClient.PlayerLeft

-- Logic
local PlayerService = {}

function PlayerService.Init()
    local Players = game:GetService("Players")

    Players.PlayerAdded:Connect(function(addedPlayer: Player)
        for _, player in Players:GetPlayers() do
            if player ~= addedPlayer then
                PlayerJoinedEvent:FireClient(player, addedPlayer)
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(removedPlayer: Player)
        PlayerLeftEvent:FireAllClients(removedPlayer)
    end)
end

return PlayerService