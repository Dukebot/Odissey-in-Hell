

let map
let characters
let items

let player
let inventory

function main() {
	map = read_json("game_data/map.json");
	characters = read_json("game_data/characters.json");
	items = read_json("game_data/items.json");
	
	player = characters["player"];
	inventory = read_json("game_data/inventory.json")
}

function move(x, y) {
	//movemos el jugador
	if (map[x][y] == " ") {
		map[player.x][player.y] = " ";
		map[x][y] = "P";
		player.x = x;
		player.y = y;
		display("You are on " + x + ", " + y);
	}
	//Barred door
	if (map[x][y] == "B") {
		if (inventory["axes"] > 0) {
			inventory["axes"]--;
			map[x][y] = " ";
			display("You destroy the Barred Door with your axe");
		} else {
			display("You need an axe to destroy a Barred Door")
		}
	}
	//...
}