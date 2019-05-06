local videos = { }

	videos.list = { }

	function videos.load(file_path)
		for i in pairs(videos.list) do
			if videos.list[i].path == file_path then
				return videos.list[i]
			end
		end

		local video = {
			resource = love.graphics.newVideo(file_path),
			path = file_path,
		}
		video.width, video.height = video.resource:getDimensions()
		videos.list[#videos.list + 1] = video
		return video
	end

	function videos.draw(video, x, y, size, facing, r, g, b, a, other)
		facing = facing and facing < 0 and -1 or 1
		other = other or { r = 0, ox = 0, oy = 0, kx = 0, ky = 0 }

		local w = size and size.width or tonumber(size) or 1
		local h = size and size.height or tonumber(size) or 1

		local ro, go, bo, ao = love.graphics.getColor()
		love.graphics.setColor(r or ro, g or go, b or bo, a or ao)
		love.graphics.draw(video.resource, x, y, other.r, w * facing, h, other.ox, other.oy, other.kx, other.ky)
		love.graphics.setColor(ro, go, bo, ao)
	end

return videos