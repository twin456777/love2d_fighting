local state = { variables = {} } -- | 4 | -- Прыжок
-- Поведение объекта в воздухе при движении вверх\\вниз и призимлении
---------------------------------------------------------------------
function state:Processing(object,s)
	if not object.grounded then
		if object.next_frame == 0 and object.wait == 0 then
			if object.vel_y > 0 then
				if s.up ~= nil then object:setFrame(s.up)
				else object:setFrame(object.frame.number) end
			else
				if s.down ~= nil then object:setFrame(s.down)
				else object:setFrame("air") end
			end
		end
	else
		if s.grounded ~= nil then object:setFrame(s.grounded)
		else object:setFrame("grounded") end
	end
end

return state