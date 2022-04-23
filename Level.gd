
extends Node2D

const ObjectScene = preload("res://entities/Object.tscn")

var velocity = 0
var score = 0
var high_score = 0

var upper_spawn_rate = 0
var lower_spawn_rate = 0

var game_started = false

func _ready():
	$StartScreen/StartButton.grab_focus()
	$StartScreen/AnimationPlayer.play("GameTitleMove")

func _physics_process(_delta):
	$ParallaxBackground.scroll_base_offset.x -= velocity
	for object in $Objects.get_children():
		object.position.x -= velocity
		if object.position.x < $DespawnPoint.position.x:
			object.queue_free()
	velocity += 1
	velocity = clamp(velocity, 0, 10)

	if game_started:
		score += 1.0
		high_score = max(high_score, score)
		$ScoreText/Score.text = str(score) + "\n" + str(high_score)

		# https://www.desmos.com/calculator/qc2doswkbj
		upper_spawn_rate = 5 * (1.14 - atan2(score / 2000, 1) / (PI / 2))
		lower_spawn_rate = 3 * (1.215 - atan2(score / 2000, 1) / (PI / 2))
		$Debug/Difficulty.text = "Difficulty:\n" + str(upper_spawn_rate) + "\n" + str(lower_spawn_rate)

func spawn_object():
	var object = ObjectScene.instance()
	object.position = $SpawnPoint.position
	$Objects.add_child(object)
	object.connect("hit_player", self, "_on_player_hit")

func start_spawn_timer():
	$ObjectSpawnTimer.start(rand_range(lower_spawn_rate, upper_spawn_rate))

func start_game():
	score = 0
	$Player.visible = true
	$StartScreen.visible = false
	start_spawn_timer()
	game_started = true

func exit_game():
	game_started = false
	$ObjectSpawnTimer.stop()
	$StartScreen.visible = true
	$StartScreen/StartButton.grab_focus()
	$Player.position = $PlayerStartPoint.position
	$Player.visible = false
	$DeathSoundPlayer.stream = Globals.get_sfx("death")
	$DeathSoundPlayer.play()

func _on_ObjectSpawnTimer_timeout():
	spawn_object()
	start_spawn_timer()

func _on_StartButton_pressed():
	start_game()

func _on_player_hit():
	$HurtSoundPlayer.stream = Globals.get_sfx("hurt")
	$HurtSoundPlayer.play()
