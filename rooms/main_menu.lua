local room = { }

	local list = ui.List(20, 50, {
			ui.Button("Play", 16, 50)
				:on("update", function (self) self.color[2] = self.hover and 0 or 1 end),

			ui.Button("Settings", 16, 100)
				:on("update", function (self) self.color[2] = self.hover and 0 or 1 end),

			ui.Button("Exit", 16, 150, nil, nil, 0, 0, nil, nil, true)
				:on("update", function (self) self.color[2] = self.hover and 0 or 1 end)
				:on("click", function () love.event.quit() end),
		})
		-- :on("change", function (self, new, old)
		-- 	old.color[3] = 1
		-- 	new.color[3] = 0
		-- end)

	room.nodes = {
		ui.Image("sprites/UI/logotype.png"),
		ui.Button("Hover me!", 160, 32, nil, nil, -32, 16, nil, "sprites/UI/small.png", true)
			:on("update", function (self) self.text = self.hover and not self.clicked and "Yeah, now click on me!" or self.text end)
			:on("click", function (self) self.text = "You're a good boy!" end),
		list,
	}

	function room:exit()
		for i = 1, #self.nodes do
			if self.nodes[i].stop then self.nodes[i]:stop() end
		end
	end

	function room:keypressed(key)
		if key == "f1" then
			rooms:set("settings")
		end
	end

return room

	--[[
	function room:load()
		self.opacity = 0.1
		self.opacity_change = 0.001
		self.background_image = image.Load("sprites/UI/background.png", nil, "linear")
		self.logotype_image = image.Load("sprites/UI/logotype.png", nil, "linear")
		self.scenes = {
			image.Load("sprites/UI/MainMenu/1.png"),
			image.Load("sprites/UI/MainMenu/2.png"),
			image.Load("sprites/UI/MainMenu/3.png"),
		}
		self.scene = math.random(1, #self.scenes)

		self.selected_mode = 1
		self.modes = {
			{
				text = locale.main_menu.versus,
				action = function ()
					rooms:set("character_select")
				end
			},
			{
				text = locale.main_menu.story,
				action = function ()
					-- ignore
				end
			},
			{
				text = loc.text.main_menu.settings,
				action = function ()
					rooms:set("settings")
				end
			},
			{
				text = locale.main_menu.exit,
				action = function ()
					love.event.quit( )
				end
			},
		}

		sounds.setMusic("music/main.mp3")
	end

	function room:update()
		self.opacity = self.opacity + self.opacity_change
		if self.opacity > 0.3 or self.opacity < 0.1 then self.opacity_change = -self.opacity_change end
	end

	function room:draw()
		image.draw(self.background_image,0,0,0)
		image.draw(self.logotype_image,0,420,25)
		image.draw(self.scenes[self.scene],0,0,settings.gameHeight - 240, 0, 2)

		for i = 1, #self.modes do
			if i == self.selected_mode then
				love.graphics.setColor(0, 0, 0, .2 + self.opacity)
				love.graphics.rectangle("fill", settings.gameWidth / 2 - 150, 370 + 65 * i, 300, 65)
				love.graphics.setColor(1, 1, 1, 1)
			end
			font.print(self.modes[i].text, settings.gameWidth / 2 - 250, 370 + 65 * i, "center", font.list.menu_element, nil, 500)
		end
	end
]]