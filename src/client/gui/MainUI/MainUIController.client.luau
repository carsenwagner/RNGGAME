--!strict

local player = game.Players.LocalPlayer
assert(player, "LocalPlayer not found!")

local playerGui = player:WaitForChild("PlayerGui")

for _, group: Instance in pairs(playerGui:WaitForChild("MainUI"):GetChildren()) do
	if not group:IsA("Folder") then
		continue
	end
	local folderName = group.Name

	for _, child: Instance in pairs(group:GetChildren()) do
		if not child:IsA("TextButton") then
			continue
		end

		child.MouseButton1Click:Connect(function()
			local frame = group:FindFirstChild(folderName .. "Frame")

			if not frame or not frame:IsA("Frame") then
				return
			end

			frame.Visible = not frame.Visible
		end)
	end
end
