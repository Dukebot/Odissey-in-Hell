extends Node

static func get_random_array_index(array: Array) -> int:
	var rand_index: int = randi() % array.size()
	return rand_index
