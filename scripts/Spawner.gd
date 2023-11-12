extends Node2D

var dir: int;
var grid: Node2D;
var base_speed = 300;
var speed_range = 50;
@onready var obj_speed = base_speed + randi_range(-speed_range, speed_range);

var base_delay = 3000;
var delay_range = 500;
@onready var obj_delay = base_delay + randi_range(-delay_range, delay_range);

var last_obj = Time.get_ticks_msec() + randi_range(-base_delay, 0);

var spawner_type;
var sprite_ids;

var obj_type;
var obj_count = 0;

const base_car_col = Color(0.3843, 0.6196, 0.9725, 1);
const base_tire_col = Color(0, 0, 0, 1);
const base_light_col = Color(1, 0, 0, 1);



# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_ids = get_sprite_id(spawner_type);
	obj_type = 'car' if spawner_type[0] == 'r' else 'log';
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_ticks_msec() > last_obj + obj_delay:
		last_obj = Time.get_ticks_msec();
		create_obj(obj_type);
	pass

func create_obj(type: String):
	var body = RigidBody2D.new();
	obj_count += 1;
	body.name = type + str(obj_count);
	add_child(body);
	body.linear_velocity.x = obj_speed * dir;
	body.gravity_scale = 0;
	body.linear_damp = 0;
	body.mass = 1;
	body.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE;
	
	var obj_parts = Node2D.new();
	body.add_child(obj_parts);
	obj_parts.scale = Vector2(0.8, 0.8);
	
	var new_color = car_colors.pick_random();
	
	var obj_len = randi_range(2, 4 if type == 'car' else 8);
	for i in obj_len:
		var sprite_dir = 1 + dir;
		var sprite_i = sprite_ids[0] if i == 0 else sprite_ids[1].pick_random();
		sprite_i = sprite_ids[0] if type == 'wa' and i == obj_len-1 else sprite_i;
		var sprite_node = grid.create_tile(sprite_i, sprite_dir, 'moving object');
		sprite_node.get_node('Sprite2D').z_index = 3;
		if type == 'car':
			var new_img = recolor(sprite_node.get_node('Sprite2D').texture.get_image(), base_car_col, new_color); 
			sprite_node.get_node('Sprite2D').texture = ImageTexture.create_from_image(new_img);
			if i != obj_len-1 and i != 0:
				new_img = recolor(sprite_node.get_node('Sprite2D').texture.get_image(), base_tire_col, new_color); 
				sprite_node.get_node('Sprite2D').texture = ImageTexture.create_from_image(new_img);
				new_img = recolor(sprite_node.get_node('Sprite2D').texture.get_image(), base_light_col, new_color); 
				sprite_node.get_node('Sprite2D').texture = ImageTexture.create_from_image(new_img);
		obj_parts.add_child(sprite_node);
		sprite_node.position.x = i * grid.tile_size * -dir;
	
	var obj_shape = CollisionShape2D.new();
	body.add_child(obj_shape);
	obj_shape.shape = RectangleShape2D.new();
	obj_shape.shape.size = Vector2(obj_len, 1) * grid.tile_size;
	obj_shape.scale = obj_parts.scale;
	obj_shape.position.x = -dir * grid.tile_size * (obj_len-1)/2 * obj_shape.scale.x;

func get_sprite_id(type: String):
	if type[0] == 'r':
		return [40, [41, 42, 43]];
	if type == 'wa':
		return [27, [24, 25, 26]]

func recolor(img, old_col, new_col):
	img.convert(Image.FORMAT_RGBA8);
	for y in 8:
		for x in 8:
			if compare_colors(img.get_pixel(x, y), old_col):
				img.set_pixel(x, y, new_col);
	return img;

func compare_colors(col1: Color, col2: Color):
	var vec1 = Vector3(col1.r, col1.g, col1.b);
	var vec2 = Vector3(col2.r, col2.g, col2.b);
	
	return vec1.distance_to(vec2) < 0.01;

const car_colors = [
	Color(0.3843, 0.6196, 0.9725, 1),
	Color(0.56, 0.56, 0.56, 1),
	Color(0.31, 0.53, 0.31, 1),
	Color(0.22, 0.22, 0.22, 1),
	Color(0.57, 0.15, 0.12, 1),
];
