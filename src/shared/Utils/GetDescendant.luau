--!strict

local function GetDescendant(root: Instance, path: { string }): Instance
	local current = root
	for _, name in ipairs(path) do
		current = current:WaitForChild(name)
	end
	return current
end

return GetDescendant
