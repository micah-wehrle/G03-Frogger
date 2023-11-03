extends Node2D

@onready var grid = $"../World Grid"
@onready var tile_size = grid.tile_size;
var sprite_scale_mult = 0.8;
@onready var sprite_scale = Vector2(grid.img_scale, grid.img_scale) * sprite_scale_mult;
var player_node;
var sprite; 


var spaces_back = 0;
const MAX_BACK = 2;
var frog_grid_x = 0;
const MAX_GRID_X = 6;

var leaping = false;
var leap_time = 100.0;
var leap_start_time = 0;
var leap_sin_scale = 0.3;
var frog_move = false;
var screen_move = false;
var slide_dir: Vector2;
var last_pos: Vector2;
var targ_pos: Vector2;

var forward = Vector2(0,-1);
var back = -forward;
var left = Vector2(-1, 0);
var right = -left;

var on_moving_platform;

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = grid.create_tile(56, 0);
	add_child(player_node);
	sprite = player_node.get_node('Sprite2D');
	sprite.scale *= sprite_scale_mult;
	sprite.z_index = 10;
	sprite.position = Vector2(tile_size * 6, -tile_size * 2);
	
	var player_body = Area2D.new();
	player_node.add_child(player_body);
	player_body.global_position = sprite.global_position;
	var body_shape = CollisionShape2D.new();
	player_body.add_child(body_shape);
	var rect_shape = RectangleShape2D.new();
	rect_shape.size = Vector2(30, tile_size * sprite_scale_mult);
	body_shape.shape = rect_shape;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leaping:
		var elapsed = Time.get_ticks_msec() - leap_start_time;
		sprite.scale = sprite_scale * (1 + sin( deg_to_rad(elapsed/leap_time * 180) )*leap_sin_scale);
		
		if frog_move:
			player_node.position = last_pos + (targ_pos - last_pos) * (elapsed/leap_time);
			pass;
		if screen_move:
			position.y = last_pos.y + slide_dir.y * (elapsed/leap_time) * tile_size;
		
		if elapsed >= leap_time:
			stop_leap_and_slide();
		
	
	elif Input.is_action_just_pressed("Forward"):
		sprite.rotation = deg_to_rad(0);
		frog_leap();
		if spaces_back == 0:
			slide_screen(forward);
		else:
			spaces_back -= 1;
			slide_frog(forward);
		
	elif Input.is_action_just_pressed("Left"):
		sprite.rotation = deg_to_rad(270);
		frog_leap();
		slide_frog(left);
		
	elif Input.is_action_just_pressed("Right"):
		sprite.rotation = deg_to_rad(90);
		frog_leap();
		slide_frog(right);
		
	elif Input.is_action_just_pressed("Back") and spaces_back < MAX_BACK:
		sprite.rotation = deg_to_rad(180);
		spaces_back += 1;
		frog_leap();
		slide_frog(back);
		
	pass

func frog_leap():
	leaping = true;
	leap_start_time = Time.get_ticks_msec();
	pass;

func slide_screen(dir: Vector2):
	screen_move = true;
	frog_move = false;
	slide_dir = dir;
	last_pos = position;
	targ_pos = find_closest_grid_pos(position + dir * tile_size);
	pass;

func slide_frog(dir: Vector2):
	if dir.y != 0 or frog_grid_x * dir.x < MAX_GRID_X:
		frog_move = true;
		screen_move = false;
		slide_dir = dir;
		last_pos = player_node.position;
		targ_pos = find_closest_grid_pos(player_node.position + dir * tile_size);
		frog_grid_x += dir.x;
	pass;

func stop_leap_and_slide():
	if screen_move:
		position = targ_pos;
	elif frog_move:
		player_node.position = targ_pos;
	leaping = false;
	screen_move = false;
	frog_move = false;
	sprite.scale = sprite_scale;
	pass;

func find_closest_grid_pos(pos: Vector2):
	return floor(pos / tile_size) * tile_size;
