extends Node2D

var world = '0gr 0gr 0gr 0gr 0rc 0rc 0rc 0rc 0rc ';
var world_index = 2;
var tile_size = 80; #10x
var img_scale = 10;

var row_tile_count = 13;

#var row_item_path = "res://scene items/world_row.tscn";

@onready var sprite_sheet = load("res://img/frogger sheet1.png");
@onready var spawner_script = load("res://scripts/Spawner.gd");

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 50:
		world = world + random_world_bit();
	
	for i in row_tile_count * 10:
		var row = build_row(get_first_world_row());
		add_child(row);
		row.position.y = -i * tile_size;
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_row(i: int):
	pass;

func get_first_world_row():
	var sub = world.substr(0,3);
	world = world.erase(0,4);
	return sub;

func build_row(row_data: String):
	var row = Node2D.new();
	
	var row_type = row_data.substr(1);
	var start_i = randi_range(0, 4);
	for i in row_tile_count:
		var tile;
		if row_type == 'wr':
			if i % 4 == start_i:
				tile = create_tile( tile_indexes[ 'wr' ].pick_random(), int(row_data[0]), true);
			else:
				tile = create_tile( tile_indexes[ 'wa' ].pick_random(), int(row_data[0]), true);
		else:
			tile = create_tile( tile_indexes[ row_type ].pick_random(), int(row_data[0]), true);
		
		row.add_child(tile);
		tile.position.x = i*tile_size;
	if row_type[0] == 'r':
		#create car spawner
		var spawner = Node2D.new();
		row.add_child(spawner);
		spawner.set_script(spawner_script);
		var dir = -1 if randf() < 0.5 else 1;
		spawner.position.x = -tile_size * 2 if dir == 1 else tile_size * (row_tile_count + 2);
		spawner.dir = dir;
		spawner.grid = self;
	return row;

func create_tile(index: int, rot: int, border: bool = false) -> Node2D:
	var node = Node2D.new();
	var sprite = Sprite2D.new();
	sprite.name = 'Sprite2D';
	node.add_child(sprite);
	var tex = AtlasTexture.new();
	tex.atlas = sprite_sheet;
	tex.region = Rect2(Vector2(index*8%64, floor(index/8)*8), Vector2(8, 8));
	
	sprite.texture = tex;
	sprite.centered = true; # has to be for rotation
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST;
	sprite.rotation_degrees = rot*90 if rot != 4 else randi_range(0,3) * 90;
	sprite.scale = Vector2(img_scale, img_scale);
	
	if border:
		var b_line = Line2D.new();
		b_line.texture = Texture2D.new();
		b_line.self_modulate = Color(0,0,0,0.1);
		node.add_child(b_line);
		b_line.add_point(Vector2(1,1) * tile_size/2.0);
		b_line.add_point(Vector2(1,-1) * tile_size/2.0);
		b_line.add_point(Vector2(-1,-1) * tile_size/2.0);
		b_line.add_point(Vector2(-1,1) * tile_size/2.0);
		b_line.add_point(Vector2(1,1) * tile_size/2.0);
		b_line.width = 2;
		
	return node;





func random_world_bit():
	return raw_world_parts.pick_random() + ' ';

var raw_world_parts = [
	'0gr', # just grass
	'0ge 0sw 2ge', # just a sidewalk
	'0ge 0sw 0ry 2ry 2sw 2ge', # 2 lane yellow road
	'0ge 0sw 0rw 2rw 2sw 2ge', # 2 lane white road
	'0ge 0sw 0rw 0rc 2rw 2sw 2ge', # 3 lane white road
	'0ge 0sw 0rw 0rc 0rc 2rw 2sw 2ge', # 4 lane white road 
	'0ge 0sw 0rw 0rc 0rc 0rc 2rw 2sw 2ge', # 5 lane white road
	'0ge 0sw 0rw 0rc 0rc 0rc 0rc 2rw 2sw 2ge', # 6 lane white road
	'0ge 0sw 0rw 0rc 0rc 0rc 0rc 0rc 0rc 0rc 0rc 2rw 2sw 2ge', # 10 lane white road
	'0we 0wa 2we', # 1 lane water
	'0we 0wa 0wa 2we', # 2 lane water
	'0we 0wa 0wa 0wa 2we', # 3 lane water
	'0we 0wa 4wr 0wa 2we', # 3 lane water
	'0we 0wa 0wa 4wr 0wa 2we', # 4 lane water
	'0we 0wa 4wr 0wa 0wa 2we', # 4 lane water
	'0we 0wa 0wa 4wr 0wa 0wa 2we', # 5 lane water
	'0we 0wa 4wr 0wa 4wr 0wa 2we', # 5 lane water
	'0we 0wa 0wa 4wr 0wa 0wa 0wa 2we', # 6 lane water
]

var tile_indexes = {
	'gr': [7], # grass
	'ge': [6], # grass edge 
	'wa': [0], # water
	'we': [10], # water edge
	'ry': [1], # road yellow
	'rw': [2], # road white
	'rc': [3], # road center
	'sw': [4], # sidewalk
	'wr': [8,9], # water random (steps)
	
	'log middle': [24,25,26],
	'log end': [27],
	'car start': [40],
	'car end': [41,42,43],
}
