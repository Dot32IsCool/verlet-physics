local intro = require('intro') -- required for access to love.setColour (australian translations)
intro:init('tests')

local inHolding = false -- a boolean for being held by the mouse

local function distance(p1, p2)
	return math.sqrt((p1.x-p2.x)^2 + (p1.y-p2.y)^2)
end

local points = {} -- a table of points to run physics on
table.insert(points, {
	x=400-30,
	y=300-30,
	xPre = 400,
	yPre = 300,
})
table.insert(points, {
	x=400+30,
	y=300-30,
	xPre = 400,
	yPre = 300,
})
table.insert(points, {
	x=400+30,
	y=300+30,
	xPre = 400,
	yPre = 300,
})
table.insert(points, {
	x=400-30,
	y=300+30,
	xPre = 400,
	yPre = 300,
})


local sticks = {} -- a table of constraints to limit point movement
table.insert(sticks, {
	p1 = points[1],
	p2 = points[2],
	length = distance(points[1], points[2]),
})
table.insert(sticks, {
	p1 = points[2],
	p2 = points[3],
	length = distance(points[2], points[3]),
})
table.insert(sticks, {
	p1 = points[3],
	p2 = points[4],
	length = distance(points[3], points[4]),
})
table.insert(sticks, {
	p1 = points[4],
	p2 = points[1],
	length = distance(points[4], points[1]),
})
table.insert(sticks, {
	p1 = points[3],
	p2 = points[1],
	length = distance(points[4], points[2]),
	hidden = true,
})
table.insert(sticks, {
	p1 = points[4],
	p2 = points[2],
	length = distance(points[4], points[2]),
	hidden = true,
})

function points.update() 
	--[[ moves the points by the diference from their current 
	position to their old one, and adds gravity]]
	love.mouse.setCursor()
	for i=1, #points do
		local p = points[i]

		local gravity = 0.2

		local xV = p.x - p.xPre
		local yV = p.y - p.yPre

		p.xPre = p.x
		p.yPre = p.y
		p.y = p.y + gravity

		p.x = p.x + xV
		p.y = p.y + yV

		if inHolding == i or distance({x=love.mouse.getX(), y=love.mouse.getY()}, points[i]) < 15 then
			love.mouse.setCursor(intro.cursor)
		end
	end
end

function points.constrain()
	for i=1, #points do
		local p = points[i]

		local bounce = 0.5
		local friction = 0.7

		local xV = p.x - p.xPre
		local yV = p.y - p.yPre

		if inHolding == i then
			p.x = love.mouse.getX()
			p.y = love.mouse.getY()
		end

		-- limits points within the screen
		if p.x > love.graphics.getWidth() then
			p.x = love.graphics.getWidth()
			p.xPre = p.x + xV * bounce -- bounces by setting previous position to current position + velocity
			p.yPre = p.y - yV * friction -- applies friction by setting prev-pos to current pos - vel*firction
		end
		if p.x < 0 then
			p.x = 0
			p.xPre = p.x + xV * bounce
			p.yPre = p.y - yV * friction
		end
		if p.y > love.graphics.getHeight() then
			p.y = love.graphics.getHeight()
			p.yPre = p.y + yV * bounce
			p.xPre = p.x - xV * friction
		end
		if p.y < 0 then
			p.y = 0
			p.yPre = p.y + yV * bounce
			p.xPre = p.x - xV * friction
		end
	end
end

function sticks.update()
	for i=1, #sticks do
		local s = sticks[i]

		-- calculates the distance a point needs to move in (for the x/y serpately)
		local xD = s.p2.x - s.p1.x
		local yD = s.p2.y - s.p1.y
		local dist = distance(s.p1, s.p2)
		local diff = s.length - dist 
		local pcnt = diff/dist*0.5
		local offX = xD*pcnt
		local offY = yD*pcnt

		s.p1.x = s.p1.x - offX
		s.p1.y = s.p1.y - offY

		s.p2.x = s.p2.x + offX
		s.p2.y = s.p2.y + offY
	end
end

function love.update()
	points.update()
	-- for more precision, loop sticks.update and constrain.update a few times (this feels less bouncy)
	for i=1, 1 do
		sticks.update()
		points.constrain()
	end
end

function love.draw()
	for i=1, #sticks do
		love.graphics.setColour(1,1,1)
		local v = sticks[i]
		if v.hidden then
			love.graphics.setColour(1,1,1, 0.5)
		end
			love.graphics.line(v.p1.x, v.p1.y, v.p2.x, v.p2.y)
	end

	-- for i=1, #points do
	-- 	love.graphics.setColour(1,1,1)
	-- 	if inHolding == i then
	-- 		love.graphics.setColour(1,0,0)
	-- 	end

	-- 	love.graphics.circle('fill', points[i].x, points[i].y, 7)
	-- end
end

function love.mousepressed(x,y,b)
	for i=1, #points do
		if distance({x=love.mouse.getX(), y=love.mouse.getY()}, points[i]) < 15 then
			inHolding = i
		end
	end
end

function love.mousereleased(x,y,b)
	inHolding = false
end

