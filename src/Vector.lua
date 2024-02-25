--!strict

local Vector = {}
Vector.__index = Vector

export type Class = typeof(setmetatable({} :: {
    _vec: Vector3
}, Vector))

local Config = require(script.Parent.Config)
local UnitScale = Config.UnitScale

local function fromVector3(vec: Vector3): Class
    vec = Vector3.new(vec.X, -vec.Z, vec.Y)

    return setmetatable({
        _vec = vec * UnitScale
    }, Vector)
end

local function fromXYZ(x: number, y: number, z: number): Class
    local vec = Vector3.new(x, y, z)
    return fromVector3(vec)
end

function Vector.__tostring(self: Class)
    local vec = self._vec
    return `({vec.X} {vec.Y} {vec.Z})`
end

local new: typeof(fromXYZ) & typeof(fromVector3) = function (...)
    local count = select("#", ...)

    if count == 1 then
        return fromVector3(...)
    elseif count == 3 then
        return fromXYZ(...)
    end

    error("Invalid argument count")
end

return table.freeze({
    new = new
})