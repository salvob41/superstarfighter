tool

extends GShape

class_name GRoundedRect

export (int) var width = 200 setget set_width
export (int) var height = 100 setget set_height
export (int) var radius = 20 setget set_radius
export (float) var precision = 10 setget set_precision

func set_width(value):
	width = value
	emit_signal('changed')

func set_height(value):
	height = value
	emit_signal('changed')
	
func set_radius(value):
	radius = value
	emit_signal('changed')
	
func set_precision(value):
	precision = value
	emit_signal('changed')

func __generate_corner(starting_angle, center):
	var sides = int(round(PI/2*radius/precision))
	var angle = PI/2/sides
	var points = []
	for i in range(sides):
		points.append(Vector2(center.x+radius*cos(starting_angle+i*angle),center.y+radius*sin(starting_angle+i*angle)))
		
	return points
	
func to_PoolVector2Array():
	var points = []
	
	points.append(Vector2(-width/2,-height/2+radius))
	points = points + __generate_corner(-PI, Vector2(-width/2+radius,-height/2+radius))
	points.append(Vector2(-width/2+radius,-height/2))
	points.append(Vector2(width/2-radius,-height/2))
	points = points + __generate_corner(-PI/2, Vector2(width/2-radius,-height/2+radius))
	points.append(Vector2(width/2,-height/2+radius))
	points.append(Vector2(width/2,height/2-radius))
	points = points + __generate_corner(0, Vector2(width/2-radius,height/2-radius))
	points.append(Vector2(width/2-radius,height/2))
	points.append(Vector2(-width/2+radius,height/2))
	points = points + __generate_corner(PI/2, Vector2(-width/2+radius,height/2-radius))
	points.append(Vector2(-width/2,height/2-radius))
	
	return PoolVector2Array(points) # clockwise!
	
func to_Shape2D():
	var shape = ConvexPolygonShape2D.new()
	shape.set_point_cloud(to_PoolVector2Array())
	return shape
	
func get_extents() -> Vector2:
	return Vector2(width, height)
	