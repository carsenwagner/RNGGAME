--!strict

local TableUtils = {}

function TableUtils.indexOf(table: {}, value: any): number
    for i, v in ipairs(table) do
        if v == value then 
            return i 
        end
    end
    return -1
end

return TableUtils