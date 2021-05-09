extends Node

static func get_random_array_index(array: Array) -> int:
	var rand_index: int = randi() % array.size()
	return rand_index


static func get_json_result(json_path: String):
	var file = File.new()
	file.open(json_path, file.READ)
	var json_string = file.get_as_text()
	var json_result = JSON.parse(json_string).result
	file.close()
	return json_result
