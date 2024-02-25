local Plane = {}
Plane.__index = Plane

export type Class = typeof(setmetatable({} :: {
    _cf: CFrame
}, Plane))

local Vector = require(script.Parent.Vector)

local function fromCFrame(cf: CFrame): Class
    return setmetatable({
        _cf = cf
    }, Plane)
end

local function fromDistAndNormal(dist: number, normal: Vector3): Class
    local origin = normal * dist
    local cf = CFrame.lookAt(origin, origin + normal)
    return fromCFrame(cf)
end

local function fromABC(a: Vector3, b: Vector3, c: Vector3)
    local dist = ((a + b + c) / 3).Magnitude
    local normal = (b - a):Cross(c - a).Unit
    return fromDistAndNormal(dist, normal)
end

function Plane.__tostring(self: Class): string
    local cf = self._cf
    local pos = cf.Position

    local b = Vector.new(pos)
    local a = Vector.new(pos + cf.UpVector)
    local c = Vector.new(pos + cf.RightVector)

    return `{a} {b} {c}`
end

local new: typeof(fromCFrame) & typeof(fromDistAndNormal) & typeof(fromABC) = function (...)
    local count = select("#", ...)

    if count == 1 then
        return fromCFrame(...)
    elseif count == 2 then
        return fromDistAndNormal(...)
    elseif count == 3 then
        return fromABC(...)
    else
        error("Invalid argument count")
    end
end

return table.freeze({
    new = new
})