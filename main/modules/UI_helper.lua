-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local COLOR_CLEAR      = vmath.vector4(0, 0, 0, 0)
local COLOR_WHITE      = vmath.vector4(1, 1, 1, 1)

local M = {}
M.__index = M

-- constructor
function M.new(node,transparent)
	local instance = setmetatable({}, M)	
		
	instance.node = node
	instance.is_hovered = false
	instance.base_scale = gui.get_scale(node)

	if (transparent) then
		gui.set_color(node, COLOR_CLEAR)
	else
		gui.set_color(node, COLOR_WHITE)
	end

	instance.is_animating = false
	return instance
end

function M:pick(x,y)
	if (gui.is_enabled(self.node)==false) then return false end
		
	return gui.pick_node(self.node, x, y) 
end

function M:set_transparent()
	gui.set_color(self.node, COLOR_CLEAR)
end

function M:set_enabled(enabled)
	gui.set_enabled(self.node, enabled)
end

function M:set_solid()
	gui.set_color(self.node, COLOR_WHITE)
end

function M:fade_in(length,delay,callback)
	self.is_animating = true
	gui.animate(self.node, gui.PROP_COLOR, COLOR_WHITE, gui.EASING_LINEAR, length,delay,
		function(gui_self, node)
			gui.set_enabled(node, true)
			self.is_animating = false
			if callback then
				callback(gui_self, node)
			end
		end, gui.PLAYBACK_ONCE_FORWARD)
end

function M:fade_out(length,delay,callback)
	self.is_animating = true
	gui.animate(self.node, gui.PROP_COLOR, COLOR_CLEAR, gui.EASING_LINEAR, length,delay,
		function(gui_self, node)
			gui.set_enabled(node, false)
			self.is_animating = false
			if callback then
				callback(gui_self, node)
			end
		end, gui.PLAYBACK_ONCE_FORWARD)
end

function M:update_hover(x,y)
	local is_hovering = gui.pick_node(self.node, x, y)

	if is_hovering and not self.is_hovered then
		gui.animate(self.node, gui.PROP_SCALE, self.base_scale * 1.2, gui.EASING_OUTQUAD, 0.1)
		self.is_hovered=  true
	elseif not is_hovering and self.is_hovered then
		gui.animate(self.node, gui.PROP_SCALE, self.base_scale, gui.EASING_OUTQUAD, 0.1)
		self.is_hovered = false
	end
end

function M:set_text(text)
	gui.set_text(self.node,text)
end

function M:reset_hover()
	if self.is_hovered then
		gui.animate(self.node, gui.PROP_SCALE, self.base_scale, gui.EASING_OUTQUAD, 0.1)
		self.is_hovered = false
	end
end

function M:reset_hover_fade_out(length,delay,callback)
	if self.is_hovered then
		gui.animate(self.node, gui.PROP_SCALE, self.base_scale, gui.EASING_OUTQUAD, 0.1)
		self.is_hovered = false
	end

	gui.animate(self.node, gui.PROP_COLOR, COLOR_CLEAR, gui.EASING_LINEAR, length,delay, callback, gui.PLAYBACK_ONCE_FORWARD)
end

return M