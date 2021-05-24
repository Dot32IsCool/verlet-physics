local function distance(p1, p2)
	return math.sqrt((p1.x-p2.x)^2 + (p1.y-p2.y)^2)
end

local points = {}
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

local sticks = {}
table.insert(sticks, {
	p1 = points[1],
	p2 = points[2],
	length = distance(points[1], points[2])
})
table.insert(sticks, {
	p1 = points[2],
	p2 = points[3],
	length = distance(points[1], points[2])
})
table.insert(sticks, {
	p1 = points[3],
	p2 = points[4],
	length = distance(points[1], points[2])
})
table.insert(sticks, {
	p1 = points[4],
	p2 = points[1],
	length = distance(points[1], points[2])
})
table.insert(sticks, {
	p1 = points[4],
	p2 = points[2],
	length = distance(points[1], points[2])
})

function points.update()
	for i=1, #points do
		local p = points[i]

		local bounce = 0.5
		local gravity = 0.2

		local xV = p.x - p.xPre
		local yV = p.y - p.yPre

		p.xPre = p.x
		p.yPre = p.y
		p.y = p.y + gravity

		p.x = p.x + xV
		p.y = p.y + yV

		if p.x > love.graphics.getWidth() then
			p.x = love.graphics.getWidth()
			p.xPre = p.x + xV * bounce
		end
		if p.x < 0 then
			p.x = 0
			p.xPre = p.x + xV * bounce
		end
		if p.y > love.graphics.getHeight() then
			p.y = love.graphics.getHeight()
			p.yPre = p.y + yV * bounce
		end
		if p.y < 0 then
			p.y = 0
			p.yPre = p.y + yV * bounce
		end
	end
end

function sticks.update()
	for i=1, #sticks do
		local s = sticks[i]

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
	sticks.update()
end

function love.draw()
	for i=1, #points do
		love.graphics.circle('fill', points[i].x, points[i].y, 7)
	end
	for i=1, #sticks do
		local v = sticks[i]
		love.graphics.line(v.p1.x, v.p1.y, v.p2.x, v.p2.y)
	end
end
