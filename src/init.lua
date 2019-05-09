local __DIR__ = (...) .. "."
gamera		= require(__DIR__ .. "external.gamera")
json 		= require(__DIR__ .. "external.json")
helper 		= require(__DIR__ .. "helper")

--battle		= require(__DIR__ .. "battle")
---------------------------------------------
camera = nil
locale = nil
---------------------------------------------

l2df = { version = 1.0 }
local core = l2df

	function core.import(name)
		return require(__DIR__ .. name)
	end

	local min_dt, next_time

	core.settings	= core.import "settings"
	-- core.resources	= core.import "resources"
	core.data		= core.import "data"
	core.i18n		= core.import "i18n"

	core.font		= core.import "fonts"
	core.sound		= core.import "sounds"
	core.image		= core.import "images"
	core.video		= core.import "videos"
	core.ui			= core.import "ui"
	core.rooms		= core.import "rooms"
	core.battle		= core.import "battle"

	core.scalex = 1
	core.scaley = 1

	function core:init(filepath)
		local _ = filepath and self.settings:load(filepath)
		self.sound:setConfig(self.settings.global)

		-- FPS Limiter initialize --
		min_dt = 1 / self.settings.graphic.fpsLimit
		next_time = love.timer.getTime()
		----------------------------

		helper.hook(self.i18n, "setLocale", function (locale) self.settings.global.lang = locale.current end, self.i18n)
		helper.hook(love, "update", self.update, self)
		helper.hook(love, "draw", self.draw, self)
		helper.hook(love, "resize", self.resize, self)

		self.rooms:init()
	end

	function core:update()
		-- Mouse position calculation --
		-- local x, y = love.mouse.getPosition( )
		-- settings.mouseX = x * (settings.gameWidth / settings.global.width)
		-- settings.mouseY = y * (settings.gameHeight / settings.global.height)

		-- FPS Limiter --
		next_time = next_time + min_dt
		----------------------------
	end

	function core:draw()
		if self.canvas then
			love.graphics.draw(self.canvas, 0, 0, 0, self.scalex, self.scaley)
		end

		-- FPS Limiter working --
		local cur_time = love.timer.getTime()
		if next_time <= cur_time then
			next_time = cur_time
			return
		end
		love.timer.sleep(next_time - cur_time)
		----------------------------

		if self.camera then
			self.camera:draw(function(l, t, w, h)
				-- if rooms.current.Draw ~= nil then
				-- 	rooms.current:Draw()
				-- end
			end)
		end

		if self.settings.debug then
			-- debug drawings
		end
	end

	function core:resize(w, h)
		self.settings.global.width = w
		self.settings.global.height = h

		self.scalex = w / self.settings.gameWidth
		self.scaley = h / self.settings.gameHeight
	end

return core