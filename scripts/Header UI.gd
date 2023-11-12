extends CanvasLayer

var dist = 0;
var record_dist = 113;

var score = 0;
var record_score = 2230.0;
const step_score = 10.0;
const token_score = 100.0;

const play_length = 1000.0 * 60; # seconds

@onready var start_time = Time.get_ticks_msec();

@onready var http = %HTTPRequest;

@onready var dist_label = $"Header Background/Distance Parent/Distance";
@onready var dist_record_label = $"Header Background/Distance Parent/Distance Record";
@onready var score_label = $"Header Background/Score Parent/Score";
@onready var score_record_label = $"Header Background/Score Parent/Score Record";
@onready var progress_bar = $"Time Parent/Time Bar";

# Called when the node enters the scene tree for the first time.
func _ready():
	http.connect('request_ready', _request_completed);
	#http.load_highscores();
	update_ui();
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value = (1 - (Time.get_ticks_msec() - start_time) / play_length) * 100;
	if progress_bar.value <= 0:
		game_over();
		get_tree().reload_current_scene();
	pass

func add_dist():
	dist += 1;
	score += step_score;
	update_ui();

func add_score(amt):
	score += amt;
	update_ui();

func update_ui():
	dist_label.text = str(round(dist));
	score_label.text = str(round(score));
	
	if dist > record_dist:
		record_dist = dist;
	if score > record_score:
		record_score = score;
	
	score_record_label.text = "Record: " + str(round(record_score));
	dist_record_label.text = "Record: " + str(round(record_dist));

func game_over():
	print(' --- ');
	print('Distance: ' + str(dist));
	print('Score: ' + str(round(score)));

func _request_completed(data):
	print(data[0]['name']);

