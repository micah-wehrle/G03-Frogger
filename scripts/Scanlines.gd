extends Node2D;

var line_width = 5;
var line1_col = Color(1,1,1,0.05);
var line2_col = Color(0,0,0,0.05);
var line1 = Line2D.new();
var line2 = Line2D.new();

var screen_w = ProjectSettings.get_setting("display/window/size/viewport_width");
var screen_h = ProjectSettings.get_setting("display/window/size/viewport_height");

# Called when the node enters the scene tree for the first time.
func _ready():
	line1.default_color = line1_col;
	line2.default_color = line2_col;
	add_child(line1);
	add_child(line2);
	line1.width = line_width;
	line2.width = line_width;
	line1.z_index = 100;
	line2.z_index = 100;
	var x = 0;
	for y in ceil(screen_h/line_width/2) + 2:
		var point = -Vector2(screen_w/2, screen_h/2);
		point += Vector2(x, y*line_width*2);
		line1.add_point(point);
		line2.add_point(point + Vector2(0,line_width));
		x = screen_w if x == 0 else 0;
		point.x = x;
		line1.add_point(point);
		line2.add_point(point + Vector2(0,line_width));
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
