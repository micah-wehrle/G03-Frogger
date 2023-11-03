extends Node2D

var dir: int;
var grid: Node2D;
var obj_speed = 300 + randi_range(-10, 10);
var obj_delay = 3000 + randi_range(-500, 500);
var last_obj = -obj_delay*10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_ticks_msec() > last_obj + obj_delay:
		last_obj = Time.get_ticks_msec();
		create_obj();
	pass

func create_obj():
	var body = RigidBody2D.new();
	add_child(body);
	body.linear_velocity.x = obj_speed * dir;
	body.gravity_scale = 0;
	body.linear_damp = 0;
	
	var obj_parts = Node2D.new();
	body.add_child(obj_parts);
	obj_parts.scale = Vector2(0.8, 0.8);
	
	var obj_len = randi_range(2, 4);
	
	for i in obj_len:
		var sprite_node = grid.create_tile(40 if i == 0 else 40 + randi_range(1,3), 1 + dir);
		sprite_node.get_node('Sprite2D').z_index = 3;
		obj_parts.add_child(sprite_node);
		sprite_node.position.x = i * grid.tile_size * -dir;
	
	var obj_shape = CollisionShape2D.new();
	body.add_child(obj_shape);
	obj_shape.shape = RectangleShape2D.new();
	obj_shape.shape.size = Vector2(obj_len, 1) * grid.tile_size;
	obj_shape.scale = obj_parts.scale;
	obj_shape.position.y = dir * grid.tile_size/2 * obj_len;
