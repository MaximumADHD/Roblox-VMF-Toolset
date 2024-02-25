--!strict

local TexVec = {}
TexVec.__index = TexVec

export type Class = typeof(setmetatable({} :: {
    Position: Vector3,
    Offset: number,
    Scale: number,
}, TexVec))

local function new(pos: Vector3, scale: number?, offset: number?): Class
    pos = Vector3.new(pos.X, -pos.Z, pos.Y)

    return setmetatable({
        Position = pos,
        Offset = offset or 0,
        Scale = scale or 1,
    }, TexVec)
end

function TexVec.__tostring(self: Class)
    local pos = self.Position
    return `[{pos.X} {pos.Y} {pos.Z} {self.Offset}] {self.Scale}`
end

return table.freeze({
    new = new
})