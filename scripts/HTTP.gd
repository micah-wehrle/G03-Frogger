extends HTTPRequest

signal request_ready(data);

const server_address = 'http://127.0.0.1:3001/frogger/'; # 'https://api.wehrle.dev/frogger/';

var current_request = '';
var json: String;
var headers = ["Content-Type: application/json"];


# Called when the node enters the scene tree for the first time.
func _ready():
	request_completed.connect(_on_request_completed);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_highscores():
	if current_request != '':
		return;
	current_request = 'highscores';
	json = '';
	make_request(); 

func submit_highscore(username: String, distance: int, score: float):
	if current_request != '':
		return;
		
	current_request = 'submit';
	json = JSON.stringify({
		'username': username,
		'distance': distance,
		'score': score
	});
	
	
	pass;

func make_request():
	request(server_address + current_request);
	#request(server_address + current_request, headers, HTTPClient.METHOD_GET if current_request == 'highscores' else HTTPClient.METHOD_POST, json);
	
func _on_request_completed(result, response_code, headers, body):
	current_request = '';
	var json = JSON.parse_string(body.get_string_from_utf8())
	request_ready.emit(json);
	pass;
