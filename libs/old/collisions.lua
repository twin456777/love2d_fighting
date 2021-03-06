collisioners = {} -- массив с информацией о всех претендентах на проверку коллизий
collisioners.itr = {}
collisioners.body = {}
collisioners.platform = {}

collisions_list = {}


function CollisionersProcessing()
	collisions_list = {}

	for i = 1, #collisioners.itr do
		if entity_list[collisioners.itr[i]] ~= nil then
			local entity = entity_list[collisioners.itr[i]]
			local entity_frame = GetFrame(entity)
			local entity_owner = entity.owner
			
			for j = 1, #collisioners.body do
				if collisioners.itr[i] ~= collisioners.body[j] and entity_list[collisioners.body[j]] ~= nil then
					local target = entity_list[collisioners.body[j]]
					local target_frame = GetFrame(target)
					local target_owner = target.owner

					local distantion = GetDistance(entity.x, entity.y, target.x, target.y)
					if distantion < (entity_frame.itr_radius + target_frame.body_radius) then
						for itr_id = 1, #entity_frame.itrs do
							local itr = CollaiderCords(entity_frame.itrs[itr_id], entity.x, entity.y, entity.z, entity_frame.centerx, entity_frame.centery, entity.facing)
							for body_id = 1, #target_frame.bodys do
								local body = CollaiderCords(target_frame.bodys[body_id], target.x, target.y, entity.z, target_frame.centerx, target_frame.centery, target.facing)
								
								if (target_owner ~= entity_owner) or (entity_frame.itrs[itr_id].friendly_fire) then

									if entity.z + itr.z * 0.5 > target.z and entity.z - itr.z * 0.5 < target.z then
										if (CheckCollision(itr, body)) then
											local collision = {
												type = "itr_to_body",
												entity_id = collisioners.itr[i],
												target_id = collisioners.body[j],
												entity_frame = entity.frame,
												target_frame = target.frame,
												itr_id = itr_id,
												body_id = body_id
											}
											table.insert(collisions_list, collision)
										end
									end
								end

							end
						end
					end
				end
			end
			
			for j = i + 1, #collisioners.itr do
				if entity_list[collisioners.itr[j]] ~= nil then
					local target = entity_list[collisioners.itr[j]]
					local target_frame = GetFrame(target)
					local target_owner = entity.owner

					local distantion = GetDistance(entity.x, entity.y, target.x, target.y)
					if distantion < (entity_frame.itr_radius + target_frame.itr_radius) then
						for itr1_id = 1, #entity_frame.itrs do
							local itr1 = CollaiderCords(entity_frame.itrs[itr1_id], entity.x, entity.y, entity.z, entity_frame.centerx, entity_frame.centery, entity.facing)
							for itr2_id = 1, #target_frame.itrs do
								local itr2 = CollaiderCords(target_frame.itrs[itr2_id], target.x, target.y, entity.z, target_frame.centerx, target_frame.centery, target.facing)
								--if (target_owner ~= entity_owner) or (entity_frame.itrs[itr_id].friendly_fire) then
									if (entity.z + itr1.z * 0.5 > target.z and entity.z - itr1.z * 0.5 < target.z) or (target.z + itr2.z * 0.5 > entity.z and target.z - itr2.z * 0.5 < entity.z) then
										if (CheckCollision(itr1, itr2)) then
											local collision = {
												type = "itr_to_itr",
												entity_id = collisioners.itr[i],
												target_id = collisioners.itr[j],
												entity_frame = entity.frame,
												target_frame = target.frame,
												itr1_id = itr1_id,
												itr2_id = itr2_id
											}
											table.insert(collisions_list, collision)
										end
									end
								--end
							end
						end
					end
				end
			end
		end
	end


	if #collisioners.platform > 0 then
		for en_id = 1, #entity_list do
			if entity_list[en_id] ~= nil then
				local entity = entity_list[en_id]
				local entity_frame = GetFrame(entity)
				for j = 1, #collisioners.platform do
					if en_id ~= collisioners.platform[j] and entity_list[collisioners.platform[j]] ~= nil then
						local target = entity_list[collisioners.platform[j]]
						local target_frame = GetFrame(target)
						local distantion = GetDistance(entity.x, entity.y, target.x, target.y)
						if distantion < target_frame.platform_radius then
							for p_id = 1, #target_frame.platforms do

								local platform = CollaiderCords(target_frame.platforms[p_id], target.x, target.y, target.z, target_frame.centerx, target_frame.centery, target.facing)

								if (entity.x < platform.x + platform.w and entity.x > platform.x and entity.z < target.z + (platform.z * 0.5) and entity.z > target.z - (platform.z * 0.5) and map.border_up - entity.y < platform.y and map.border_up - entity.y > platform.y - platform.h) then
									local collision = {
										type = "unit_to_platform",
										entity_id = collisioners.platform[j],
										target_id = en_id,
										platform_id = p_id
									}
									table.insert(collisions_list, collision)
								end
							end
						end
					end
				end
			end
		end
	end
	
	collisioners.itr = {}
	collisioners.body = {}
	collisioners.platform = {}

end



function CheckCollision(c1,c2)
	return c1.x < c2.x + c2.w and c2.x < c1.x + c1.w and c1.y < c2.y + c2.h and c2.y < c1.y + c1.h
end

function CenterCollision(c1,c2)

	local xvalues = { c1.x, c1.x + c1.w, c2.x, c2.x + c2.w}
	local yvalues = { c1.y, c1.y + c1.h, c2.y, c2.y + c2.h}
			 	
 	for i=1,4 do
 	 	for j=1,4 do
 	 		if xvalues[j] > xvalues[i] then
 	 			local xv = xvalues[j]
 	 			xvalues[j] = xvalues[i]
 	 			xvalues[i] = xv
 	 		end
 	 		if yvalues[j] > yvalues[i] then
 	 			local yv = yvalues[j]
 	 			yvalues[j] = yvalues[i]
 	 			yvalues[i] = yv
 	 		end
 	 	end
 	end -- сортировка массивов для нахождения краёв "пересечения"

 	local collision_center_x = (xvalues[2] + xvalues[3]) / 2
 	local collision_center_y = map.border_up - (yvalues[2] + yvalues[3]) / 2
 	--[ нахождение центров пересечения коллайдеров ]

 	return collision_center_x, collision_center_y

end


function CollaiderCords(collaider, x, y, z, centerx, centery, facing)
	local real_cords = {
		x,
		y = map.border_up + collaider.y - y + z - centery,
		w = collaider.w,
		h = collaider.h,
		z = collaider.z
	}
	if facing == 1 then 
		real_cords.x = x + (collaider.x - centerx)
	else
		real_cords.x = x - (collaider.x - centerx) - collaider.w
	end
	return real_cords
end




function CollisionsProcessing()

	for c_id = 1, #collisions_list do
	local collision = collisions_list[c_id]

		if collision.type == "itr_to_body" then -- обработка удара itr'a по body
			
			local attacker = entity_list[collision.entity_id] -- получаем атакующего
			local target = entity_list[collision.target_id] -- получаем атакуемого
			
			local attacker_frame = attacker.frames[collision.entity_frame] -- фрейм атакующего
			local target_frame = target.frames[collision.target_frame] -- фрейм атакуемого

			local itr = attacker_frame.itrs[collision.itr_id] -- получаем itr атакующего
			local body = target_frame.bodys[collision.body_id] -- получаем body атакуемого


			if itr.kind == 1 then -- если kind: 1 (обычная атака)

				local itr_real = CollaiderCords(itr, attacker.x, attacker.y, attacker.z, attacker_frame.centerx, attacker_frame.centery, attacker.facing) -- получение реальных координат итра
				local body_real = CollaiderCords(body, target.x, target.y, target.z, target_frame.centerx, target_frame.centery, target.facing) -- получение реальных координат боди
				local collision_center_x, collision_center_y = CenterCollision(itr_real, body_real) -- вычисление центра столкновения коллайдеров
				
				local damage = target.damage[itr.damage_type + 1] -- тип урона
				
				if damage == nil or damage == 0 then
					damage = target.damage[1]
				end -- если цель не имеет определений для данного типа урона, берется стандарт

				local spark = 0 -- основа для спарка
				local injury_frame = 0 -- основа для фрейма урона

				attacker.arest = itr.arest -- установка таймера до следующего нанесения урона атакующим
				target.vrest = itr.vrest -- установка таймера до следующего получения урона целью

				if target.defend > 0 then -- если цель не пробита
					
					target.defend = target.defend - math.floor(itr.bdefend * damage.defend_modifier) -- уменьшаем броню цели
					
					if target.defend <= 0 then -- если пробили броню
						spark = itr.bdspark -- устанавливаем спарк пробития брони

						if #damage.bdefend > 0 then
							injury_frame = damage.bdefend[math.random(1, #damage.bdefend)]
						elseif #target.damage[1].bdefend > 0 then
							injury_frame = target.damage[1].bdefend[math.random(1, #target.damage[1].bdefend)]
						end

						if itr.target_frame ~= 0 then
							injury_frame = itr.target_frame
						end -- если в itr'e задан определённый кадр

						if body.injury_frame ~= 0 then
							injury_frame = body.injury_frame
						end -- если в body задан опреелённый кадр

						target.defend_timer = 240 -- ставим таймер восстановления брони
						
						target.taccel_x = target.taccel_x + (itr.dvx * attacker.facing) * 1.0 -- устанавливаем атакуемому dvx
						if itr.x_repulsion then
							target.taccel_x = target.taccel_x + attacker.vel_x
						end -- опция при которой врага отталкивает в зависимости от скорости атакующего
						if damage.y_repulsion or target.fall - itr.fall < 1 then
							target.taccel_y = target.taccel_y + itr.dvy * 1.0 -- устанавливаем атакуемому dvy
							if itr.y_repulsion then
								target.taccel_y = target.taccel_y + attacker.vel_y
							end -- опция при которой врага отталкивает в зависимости от скорости атакующего
						end -- если в типе урона указана данная опция, отталкивание по dvy работает даже без fall: -1
						
						target.hp = target.hp - math.floor(itr.injury * 1.1 * damage.damage_modifier)  -- нанесение урона
						
						if target.fall > 1 then
							target.fall = target.fall - itr.fall -- вычисление fall'a
							target.fall_timer = 120 -- ставим таймер восстановления fall'a
							if target.fall <= 0 then -- если fall упал ниже нуля
								if itr.not_knocking_down then -- проверка на то, что атака может сбить с ног
									target.fall = 1 -- если атака не должна сбивать с ног не при каких условиях
									if #damage.stun > 0 then
										injury_frame = damage.stun[math.random(1, #damage.stun)]
									elseif #target.damage[1].stun > 0 then
										injury_frame = target.damage[1].stun[math.random(1, #target.damage[1].stun)]
									end
								else
									if #damage.fall > 0 then
										injury_frame = damage.fall[math.random(1, #damage.fall)]
									elseif #target.damage[1].fall > 0 then
										injury_frame = target.damage[1].fall[math.random(1, #target.damage[1].fall)]
									end
								end
								spark = itr.fspark -- устанавливаем спарк падения
							end
						else
							target.fall_timer = target.fall_timer + 10
							injury_frame = -1
						end
						
					else -- если не смогли пробить броню
						
						spark = itr.dspark -- устанавливаем спарк удара в броню
						target.defend_timer = 120 -- ставим таймер восстановления брони
						
						target.taccel_x = target.taccel_x + (itr.dvx * attacker.facing) * 0.9 -- устанавливаем атакуемому dvx
						if itr.x_repulsion then
							target.taccel_x = target.taccel_x + attacker.vel_x
						end -- опция при которой врага отталкивает в зависимости от скорости атакующего
						
						target.hp = target.hp - math.floor(itr.injury * 0.1 * damage.damage_modifier) -- нанесение урона
					end

				else -- если брони у цели не осталось

					spark = itr.spark -- устанавливаем обычный спарк

					if #damage.injury > 0 then
						injury_frame = damage.injury[math.random(1, #damage.injury)]
					elseif #target.damage[1].injury > 0 then
						injury_frame = target.damage[1].injury[math.random(1, #target.damage[1].injury)]
					end -- устанавливаем кадр урона

					if itr.target_frame ~= 0 then
						injury_frame = itr.target_frame
					end -- если в itr'e задан определённый кадр, ставим его

					if body.injury_frame ~= 0 then
						injury_frame = body.injury_frame
					end -- если в body задан опреелённый кадр, ставим его

					target.defend_timer = 120 -- устанавливаем таймер восстановления брони
					
					target.taccel_x = target.taccel_x + (itr.dvx * attacker.facing) * 1.0 -- устанавливаем атакуемому dvx
					if itr.x_repulsion then
						target.taccel_x = target.taccel_x + attacker.vel_x
					end -- опция при которой врага отталкивает в зависимости от скорости атакующего
					if damage.y_repulsion or target.fall - itr.fall < 1 then
						target.taccel_y = target.taccel_y + itr.dvy * 1.0 -- устанавливаем атакуемому dvy
						if itr.y_repulsion then
							target.taccel_y = target.taccel_y + attacker.vel_y
						end -- опция при которой врага отталкивает в зависимости от скорости атакующего
					end -- если в типе урона указана данная опция, отталкивание по dvy работает даже без fall: -1

					target.hp = target.hp - math.floor(itr.injury * 1.0 * damage.damage_modifier) -- нанесение урона
					
					if target.fall > 1 then
						target.fall = target.fall - itr.fall -- вычисление fall'a
						target.fall_timer = 120 -- ставим таймер восстановления fall'a
						if target.fall <= 0 then -- если fall упал ниже нуля
							if itr.not_knocking_down then -- проверка на то, что атака может сбить с ног
								target.fall = 1 -- если атака не должна сбивать с ног не при каких условиях
								if #damage.stun > 0 then
									injury_frame = damage.stun[math.random(1, #damage.stun)]
								elseif #target.damage[1].stun > 0 then
									injury_frame = target.damage[1].stun[math.random(1, #target.damage[1].stun)]
								end -- установка кадра стана
							else
								if #damage.fall > 0 then
									injury_frame = damage.fall[math.random(1, #damage.fall)]
								elseif #target.damage[1].fall > 0 then
									injury_frame = target.damage[1].fall[math.random(1, #target.damage[1].fall)]
								end -- установка кадра падения
							end
							spark = itr.fspark -- устанавливаем спарк падения
						end
					else
						target.fall_timer = target.fall_timer + 10
						injury_frame = -1
					end

				end

				if target.type == "object" then -- если мы били объект
					spark = itr.ospark -- устанавливаем спарк удара по объекту
				end

				if spark ~= -1 then
					SpawnEntity(loading_list.system.sparks, collision_center_x + (itr.dvx * 0.5 + math.random(0, itr.w * 0.1)) * attacker.facing, collision_center_y + attacker.z + math.random(-itr.h * 0.1, itr.h * 0.1), (attacker.z + target.z) * 0.5 + 5, attacker.facing, spark)
				end -- создание спарка

				if injury_frame ~= -1 then
					SetFrame(target, injury_frame) -- перевод объекта в кадры повреждения
				end
			end
		end
	end
end


function CollaidersFind (en_id)

	local en = entity_list[en_id]
	local frame = GetFrame(en)

	if en.collision then -- если коллизии включены, выполняется проверка на наличие коллайдеров в текущем кадре. если коллайдеры имеются, они заносятся в списки для дальнейшей обработки
		if (en.arest == 0) and (frame.itr_radius > 0) then
			table.insert(collisioners.itr, en_id)
		end
		if (en.vrest == 0) and (frame.body_radius > 0) then
			table.insert(collisioners.body, en_id)
		end
		if (frame.platform_radius > 0) then
			table.insert(collisioners.platform, en_id)
		end
	end

end