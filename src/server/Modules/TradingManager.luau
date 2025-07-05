--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules
local TableUtils = require(ReplicatedStorage.Shared.Modules.TableUtils)
local InventoryManager = require(script.Parent.InventoryManager)
local InventoryServices = require(ServerScriptService.Server.Services.InventoryServices)

-- Remote Events
local TradeConfirmedEvent: RemoteEvent = ReplicatedStorage.Remotes.Trading.Events.ServerToClient.TradeConfirmed
local TradeCanceledEvent: RemoteEvent = ReplicatedStorage.Remotes.Trading.Events.ServerToClient.TradeCanceled
local ForceCancelTradeEvent: RemoteEvent = ReplicatedStorage.Remotes.Trading.Events.ServerToClient.ForceCancelTrade
local TradeUncomfirmedEvent: RemoteEvent = ReplicatedStorage.Remotes.Trading.Events.ServerToClient.TradeUnconfirmed
local TradeCompleteEvent: RemoteEvent = ReplicatedStorage.Remotes.Trading.Events.ServerToClient.TradeComplete

-- Logic
local TradingManager = {}
TradingManager.__index = TradingManager

export type TradingManager = typeof(setmetatable({} :: {
    -- Private variables
    player1: Player,
    player2: Player,
    Inventories: { [Player]: InventoryManager.InventoryManager? },
    Offers: { [Player]: { [string]: number } },
    Confirmed: { [Player]: boolean },
    Active: boolean,

    -- Methods
    AddToOffer: (self: TradingManager, player: Player, itemName: string) -> (),
    RemoveFromOffer: (self: TradingManager, player: Player, itemName: string) -> (),
    Confirm: (self: TradingManager, player: Player) -> (),
    UnConfirm: (self: TradingManager, player: Player) -> (),
    Cancel: (self: TradingManager, player: Player) -> (),
    ForceCancel: (self: TradingManager, reason: string) -> (),
    ExecuteTrade: (self: TradingManager) -> (),
    GetOtherPlayer: (self: TradingManager, player: Player) -> Player,
    GetCurrentOffers: (self: TradingManager) -> { [Player]: { [string]: number }},
    GetOfferFromPlayer: (self: TradingManager) -> { [string]: number },
    
}, TradingManager))

function TradingManager.new(player1: Player, player2: Player): TradingManager
    local self= setmetatable({
        player1 = player1,
        player2 = player2,

        Inventories = {
            [player1] = InventoryServices.get(player1),
            [player2] = InventoryServices.get(player2),
        },

        Offers = {
            [player1] = {},
            [player2] = {},
        },

        Confirmed = {
            [player1] = false,
            [player2] = false,
        },

        Active = false,

    }, TradingManager) :: any
    return self
end

function TradingManager:AddToOffer(player: Player, itemName: string, count: number)
    local currentCount = self.Offers[player][itemName] or 0
    self.Offers[player][itemName] = currentCount + count
end

function TradingManager:RemoveFromOffer(player: Player, itemName: string, count: number)
    local currentCount = self.Offers[player][itemName] or 0
    local newCount = currentCount - count

    if newCount <= 0 then
        self.Offers[player][itemName] = nil
    else
        self.Offers[player][itemName] = newCount
    end
end

function TradingManager:Confirm(player: Player)
    if not self.Active or self.Confirmed[player] then return end
    self.Confirmed[player] = true
    TradeConfirmedEvent:FireClient(self:GetOtherPlayer(player))
end

function TradingManager:UnConfirm(player: Player)
    if not self.Active or not self.Confirmed[player] then return end
    self.Confirmed[player] = false
    TradeUncomfirmedEvent:FireClient(self:GetOtherPlayer(player))
end

function TradingManager:Cancel(player: Player)
    if not self.Active then return end
    TradeCanceledEvent:FireClient(self:GetOtherPlayer(player))
    self.Active = false
end

function TradingManager:ForceCancel(reason: string)
    ForceCancelTradeEvent:FireClient(self.player1, reason)
    ForceCancelTradeEvent:FireClient(self.player2, reason)
end

function TradingManager:ExecuteTrade()
    if not self.Active then return end
    
    for _, item in pairs(self.Offers[self.player1]) do
        self.Inventories[self.player2]:AddItem(item)
        self.Inventories[self.player1]:RemoveItem(item)
    end

    for _, item in pairs(self.Offers[self.player2]) do 
        self.Inventories[self.player1]:AddItem(item)
        self.Inventories[self.player2]:RemoveItem(item)
    end

    TradeCompleteEvent:FireClient(self.player1)
    TradeCompleteEvent:FireClient(self.player2)
    self.Active = false
end

function TradingManager:GetOtherPlayer(player: Player): Player
    if player == self.player1 then
        return self.player2
    end
    return self.player1
end

function TradingManager:GetCurrentOffers(): { [Player]: { [string]: number} }
    return self.Offers
end

function TradingManager:GetOfferFromPlayer(player: Player): { string: number }
    return self.Offers[player]
end

return TradingManager