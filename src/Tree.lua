--!strict

local Tree = {}
Tree.__index = Tree

export type Class = typeof(setmetatable({} :: {
    _id: number,
    _type: string,

    _props: {{
        [string]: any,
    }},

    _children: { Class },
}, Tree))

local ID = 0

function Tree.new(typeId: string): Class
    ID += 1

    return setmetatable({
        _id = ID,
        _type = typeId,

        _props = {},
        _children = {},
    }, Tree)
end

function Tree.AddChild(self: Class, id: string): Class
    local child = Tree.new(id)
    table.insert(self._children, child)
    return child
end

function Tree.AddItem(self: Class, key: string, value: any): Class
    table.insert(self._props, { 
        [key] = value 
    })

    return self
end

function Tree.Write(self: Class, writeLine: (...any) -> (), _depth: number?)
    local depth = _depth or -1
    local st = string.rep("\t", depth)
    
    if depth >= 0 then
        writeLine(`{st}{self._type}`)
        writeLine(`{st}\{`)
        writeLine(`{st}\t"id" "{self._id}"`)
    end

    for _, prop in ipairs(self._props) do
        for key, value in pairs(prop) do
            local str = tostring(value)
            writeLine(`{st}\t"{key}" "{str}"`)
        end
    end

    for i, child in self._children do
        child:Write(writeLine, depth + 1)
    end

    if depth >= 0 then
        writeLine(`{st}\}`)
    end
end

function Tree.__tostring(self: Class)
	return `{self._type} [{self._id}]`
end

return Tree