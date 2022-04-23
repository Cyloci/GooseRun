extends StaticBody2D

signal hit_player

func _ready():
	var sprites = $Sprites.get_children()
	for sprite in sprites:
		sprite.visible = false
	var sprite = sprites[randi() % sprites.size()]
	sprite.visible = true
	while sprite.name == "Goose":
		$GooseHonkPlayer.pitch_scale = rand_range(0.8, 1.2)
		$GooseHonkPlayer.play()
		$Timer.start(rand_range(0.3, 0.5)); yield($Timer, "timeout")

func _on_Area2D_body_entered(body):
	if body is Player:
		emit_signal("hit_player")
