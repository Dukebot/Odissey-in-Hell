let map
let characters
let items

let player
let inventory

let game_states = ["move", "combat"]
let game_state = "move"

function main() {
	map = read_json("game_data/map.json");
	characters = read_json("game_data/characters.json");
	items = read_json("game_data/items.json");
	
	player = characters["player"];
	inventory = read_json("game_data/inventory.json")

	//Game loop, keep asking what he wants to do until it dies or the game ends
	while (true) {
		if (game_state == "move") {
			let x, y = get_movement_input()
			move(x, y)
		} else if (game_state == "combat") {
			
		}
	}
}

function move(x, y) {
	//Wall
	if (map[x][y] == "#") {
		display("You strike against a wall");
	}
	//Move the player
	else if (map[x][y] == " ") {
		map[player.x][player.y] = " ";
		map[x][y] = "P";
		player.x = x;
		player.y = y;
		display("You are on " + x + ", " + y);
	}
	//Barred door
	else if (map[x][y] == "B") {
		if (inventory["axes"] > 0) {
			inventory["axes"]--;
			map[x][y] = " ";
			display("You destroy the Barred Door with your axe");
		} else {
			display("You need an axe to destroy a Barred Door")
		}
	}
	//Cracked wall
	else if (map[x][y] == "W") {
		if (inventory["explosives"] > 0) {
			inventory["explosives"]--;
			map[x][y] = " ";
			display("You destroy the Cracked wall with an explosive");
		} else {
			display("You need an explosive to destroy a Cracked Wall")
		}
	}
	//Caramel
	else if (map[x][y] == "C") {
		inventory["caramels"]++
		map[x][y] = " "
		display("You've found a Caramel")
	}
	//Antidote
	else if (map[x][y] == "A") {
		inventory["antidotes"]++
		map[x][y] = " "
		display("You've found an Antidote")
	}
	//Ax
	else if (map[x][y] == "X") {
		inventory["axes"]++
		map[x][y] = " "
		display("You've found an Axe")
	}
	//Explosive
	else if (map[x][y] == "E") {
		inventory["explosives"]++
		map[x][y] = " "
		display("You've found an Explosive")
	}
	//Masamune
	else if (map[x][y] == "M") {
		player["weapon"] = "masamune"
		map[x][y] = " "
		display("You've found the Masamune!")
	}
	//Onyx armor
	else if (map[x][y] == "O") {
		player["armor"] = "onyx_armor"
		map[x][y] = " "
		display("You've found the Onyx Armor!")
	}
	//Necronomicon
	else if (map[x][y] == "N") {
		player["weapon"] = "necronomicon"
		map[x][y] = " "
		display("You've found the Necronomicon!")
	}
	//Lesset Demon
	else if (map[x][y] == "L") {
		
	}
	//Succubus
	else if (map[x][y] == "S") {
		
	}
	//Hell prision Guard
	else if (map[x][y] == "H") {
		
	}
	//Gaahl
	else if (map[x][y] == "G") {
		
	}
}