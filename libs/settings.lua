local fs = love.filesystem
local settings = { }

	--- Bootstrap game settings, set default values.
	function settings:init()

		self.gamePath = fs.getSourceBaseDirectory()
		fs.mount(self.gamePath, "")

		self.global = {}								-- Таблица с настройками, доступными для изменения пользователем

		self.file = "data/settings.s" 					-- Путь файла настроек игры
		self.global.data = "data/data.c"				-- Путь до data.txt (список объектов и карт движка)
		self.global.frames = "data/frames.c" 			-- Путь до frames.dat (список кадров по умолчанию)
		self.global.combos = "data/combos.c"			-- Путь до combos.dat (список переходов по комбинациям клавиш)
		self.global.dtypes = "data/dtypes.c"			-- Путь до dtypes.dat (список поведения при разных типах урона)
		self.global.system = "data/system.c"

		self.global.roomsFolder 	= "/rooms/" 		-- Папка с файлами комнат
		self.global.statesFolder 	= "/data/states/"	-- Папка с файлами стейтов
		self.global.kindsFolder 	= "/data/kinds/"	-- Папка с файлами типов взаимодействий
		self.global.localesFolder	= "/data/locales/"	-- Папка с файлами локализаций
		self.global.UIFolder		= "/sprites/UI/"	-- Папка с элементами оформления

		self.resolutions = {							-- Доступные разрешения холста игры
			{ width = 854, height = 480 },					-- 854х480
			{ width = 1024, height = 576 },					-- 1024х576
			{ width = 1280, height = 720 },					-- 1280х720
			{ width = 1366, height = 768 },					-- 1366х768
			{ width = 1600, height = 900 },					-- 1600х900
			{ width = 1920, height = 1080 },				-- 1920х1080
		}

		self.global.resolution 		= 3					-- Текущее разрешение холста
		self.gameWidth		 		= 1024 				-- Ширина холста игры
		self.gameHeight				= 576 				-- Высота холста игры

		self.global.windowWidth		= 1024 				-- Ширина окна игры
		self.global.windowHeight	= 576 				-- Высота окна игры

		self.global.musicVolume 	= 50				-- Громкость музыки
		self.global.soundVolume 	= 100				-- Громкость звука

		self.global.graphic = {							-- Настройки графической составляющей игры
			fullscreen 			= false,					-- Полный экран
			fpsLimit 			= 60,						-- Ограничение FPS
			vsync 				= false, 					-- Вертикальная синхронизация
			shadows 			= true, 					-- Детализированные тени
			reflections			= true,						-- Отражения
			smoothing			= true, 					-- Фильтрация текстур
			effects				= true,						-- Количество эффектов и частиц
			details 			= true,						-- Показ необязательных элементов
		}

		self.global.difficulty 		= 2 				-- Сложность игры (от 1 до 3)

		self.global.localization 	= 1 				-- Выбранный файл локализации
		self.global.startRoom 		= "game_start"		-- Начальная комната
		self.global.debug 			= true 				-- Показ отладочной информации

		self.global.controls = {						-- Настройки управления
			{
				name = "Player 1",
				up = "w", down = "s", left = "a", right = "d",
			  	attack = "f", jump = "g", defend = "h",
			  	special1 = "j"
			},
			{
				name = "Player 2",
				up = "o", down = "l", left = "k", right = ";",
			  	attack = "p", jump = "[", defend = "]",
			  	special1 = "\\"
			}
		}

		self:updateResolution()
	end

	--- Load game settings from settings.file
	function settings:load()
		local settings_data = fs.read(self.file)
		if settings_data then
			local settings_array = json:decode(settings_data)
			for key, val in pairs(settings_array) do
				self.global[key] = val
			end
		end
		self:save()
	end

	--- Save game settings to settings.filefile
	function settings:save()
		local save_string = json:encode_pretty(self.global)
		local settings_file = io.open(fs.getSource() .. "/" .. self.file,"w")
		settings_file:write(save_string)
		settings_file:flush()
		settings_file:close()
	end

	--- Apply game settings
	function settings:apply()
		love.graphics.setDefaultFilter("nearest", "nearest")
		math.randomseed(love.timer.getTime())
	end

	--- Update window size by settings
	function settings:updateResolution(w, h)
		if not (w and h) then
			w = self.resolutions[self.global.resolution].width
			h = self.resolutions[self.global.resolution].height
		end
		self.global.gameWidth = w
		self.global.gameHeight = h

		love.window.setMode(w, h)
		love.window.setFullscreen(self.global.graphic.fullscreen)
		if self.global.graphic.fullscreen then
			w, h = love.window.getMode() 
		end

		camera = gamera.new(0, 0, self.global.gameWidth, self.global.gameHeight)
		camera:setWindow(0, 0, w, h)
		self.cameraScale = h / self.global.gameHeight
		camera:setScale(self.cameraScale)
		self.global.windowHeight = h
		self.global.windowWidth = w
	end

return settings