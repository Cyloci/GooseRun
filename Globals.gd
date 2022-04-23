extends Node

const NUM_HURT_SOUNDS = 8
const NUM_DEATH_SOUNDS = 10
const NUM_JUMP_SOUNDS = 4

var sfx = {
	"hurt": [],
	"jump": [],
	"death": [],
}

func _ready():
	for i in NUM_HURT_SOUNDS:
		sfx['hurt'].append(load("res://assets/hurt-sounds/" + str(i+1) + ".wav"))
	for i in NUM_DEATH_SOUNDS:
		sfx['death'].append(load("res://assets/death-sounds/" + str(i+1) + ".wav"))
	for i in NUM_JUMP_SOUNDS:
		sfx['jump'].append(load("res://assets/jump-sounds/" + str(i+1) + ".wav"))

func get_sfx(type):
	var sounds = sfx[type]
	return sounds[randi() % sounds.size()]
