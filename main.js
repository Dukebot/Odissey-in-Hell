

let map
let characters
let items

let player
let inventory = {
	"axes": 0
}


function main() {
	map = read_json("game_data/map.json");
	characters = read_json("game_data/characters.json");
	items = read_json("game_data/items.json");
	
	player = characters["player"];
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
	if (map[x][y]) == "B") {
		if inventory["axes"] > 0 {
			inventory["axes"]--;
			map[x][y] = " ";
			display("You destroy the barred door with your axe");
		}
	}
	//...
}