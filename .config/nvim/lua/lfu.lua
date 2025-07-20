--- @class LFUCache.CacheValue
--- A map from keys to their values and frequencies.
--- @field value any The value associated with the key.
--- @field freq number The frequency of access for the key.
---

--- @class LFUCache.Node
--- A node in the linked list representing a key in the LFU cache.
--- @field key any The key associated with this node.
--- @field prev? LFUCache.Node The previous node in the linked list.
--- @field next? LFUCache.Node The next node in the linked list.

--- @class LFUCache.List
--- A map from frequencies to linked lists of nodes.
--- @field head? LFUCache.Node The head of the linked list for this frequency.
--- @field tail? LFUCache.Node The tail of the linked list for this frequency.

--- @class LFUCache
--- A class implementing a Least Frequently Used (LFU) cache.
--- It maintains a fixed capacity and evicts the least frequently used items when the capacity is exceeded.
--- @field capacity number The maximum number of items the cache can hold.
--- @field size number The current number of items in the cache.
--- @field kv_map table<any, LFUCache.CacheValue> A map from keys to their values and frequencies.
--- @field freq_map table<any, LFUCache.List> A map from frequencies to linked lists of nodes.
--- @field node_map table<any, LFUCache.Node> A map from keys to their corresponding nodes in the linked list.
--- @field min_freq number The minimum frequency of access among the items in the cache.

--- @class LFUCache
local M = {
    capacity = 0,
    size = 0,
    kv_map = {},
    freq_map = {},
    node_map = {},
    min_freq = 0,
}
M.__index = M

--- @param capacity number The maximum number of items the cache can hold.
--- @return LFUCache
function M.new(capacity)
    assert(capacity > 0, 'Capacity must be greater than 0')
    local self = setmetatable({}, M)
    self.capacity = capacity
    self.size = 0
    self.kv_map = {}
    self.freq_map = {}
    self.node_map = {}
    self.min_freq = 0
    return self
end

--- @return LFUCache.Node
local function new_node(key) return { key = key } end

--- @param node? LFUCache.Node
local function check_node(node)
    if not node then return end
    assert(node.next == nil or node.next.prev == node, 'Node next pointer is invalid')
    assert(node.prev == nil or node.prev.next == node, 'Node prev pointer is invalid')
end

--- @param list LFUCache.List
--- @param node LFUCache.Node
local function add_to_head(list, node)
    node.prev = nil
    node.next = list.head
    if list.head then list.head.prev = node end
    list.head = node
    if not list.tail then list.tail = node end
    check_node(node)
    check_node(list.head)
end

--- @param list LFUCache.List
--- @param node LFUCache.Node
local function remove_node(list, node)
    if node.prev then
        node.prev.next = node.next
    else
        list.head = node.next
    end
    if node.next then
        node.next.prev = node.prev
    else
        list.tail = node.prev
    end
    check_node(node.prev)
    check_node(node.next)
end

--- @param key any The key to retrieve from the cache.
--- @return any The value associated with the key, or nil if the key is not found.
function M:get(key)
    if not self.kv_map[key] then return nil end
    self:_increase_freq(key)
    return self.kv_map[key].value
end

--- @param key any The key to set in the cache.
--- @param value any The value to associate with the key.
--- @return any, any The key and value that is deleted from the cache if it was full, or nil if no eviction occurred.
function M:set(key, value)
    local deleted_key, deleted_value
    if self.kv_map[key] then
        self.kv_map[key].value = value
        self:_increase_freq(key)
    else
        if self.size == self.capacity then
            deleted_key, deleted_value = self:_evict()
        end
        local freq = 1
        self.kv_map[key] = { value = value, freq = freq }
        self.node_map[key] = new_node(key)
        self.freq_map[freq] = self.freq_map[freq] or { head = nil, tail = nil }
        add_to_head(self.freq_map[freq], self.node_map[key])
        self.min_freq = freq
        self.size = self.size + 1
    end
    return deleted_key, deleted_value
end

--- @param key any
function M:_increase_freq(key)
    local freq = self.kv_map[key].freq
    local node = self.node_map[key]
    local old_list = self.freq_map[freq]
    remove_node(old_list, node)
    if not old_list.head then
        self.freq_map[freq] = nil
        if self.min_freq == freq then self.min_freq = freq + 1 end
    end
    freq = freq + 1
    self.kv_map[key].freq = freq
    self.freq_map[freq] = self.freq_map[freq] or { head = nil, tail = nil }
    add_to_head(self.freq_map[freq], node)
end

--- @return any, any The key and value that is deleted from the cache
function M:_evict()
    local list = self.freq_map[self.min_freq]
    local node = list.tail
    assert(node, 'You can only evict when cache is full')
    remove_node(list, node)
    local key = node.key
    local value = self.kv_map[key].value
    self.kv_map[key] = nil
    self.node_map[key] = nil
    if not list.head then self.freq_map[self.min_freq] = nil end
    self.size = self.size - 1
    return key, value
end

--- @return any the deleted value, nil if not in the cache
function M:del(key)
    if not self.kv_map[key] then return end

    local freq = self.kv_map[key].freq
    local deleted_value = self.kv_map[key].value
    local node = self.node_map[key]
    local list = self.freq_map[freq]

    remove_node(list, node)

    if not list.head then
        self.freq_map[freq] = nil
        if self.min_freq == freq then
            self.min_freq = math.huge
            for f in pairs(self.freq_map) do
                if f < self.min_freq then self.min_freq = f end
            end
            if self.min_freq == math.huge then self.min_freq = 0 end
        end
    end

    self.kv_map[key] = nil
    self.node_map[key] = nil
    self.size = self.size - 1

    return deleted_value
end

--- Clear the cache
function M:clear()
    self.kv_map = {}
    self.freq_map = {}
    self.node_map = {}
    self.size = 0
    self.min_freq = 0
end

return M
