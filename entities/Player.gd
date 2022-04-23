class_name Player
extends KinematicBody2D

export (int) var jump_speed = 1000
export (int) var gravity = 3000

var velocity = Vector2.ZERO
var start_position = Vector2.ZERO
var is_on_ground = true

func _ready():
	start_position = position

func _input(event):
	if event is InputEventScreenTouch and is_on_floor():
		velocity.y = -jump_speed

func _physics_process(delta):
	velocity.x = 0
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		$JumpSoundPlayer.stream = Globals.get_sfx("jump")
		$JumpSoundPlayer.play()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_ground:
		$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.play("Jump")

	if position.x < get_node("../DespawnPoint").position.x:
		get_node("..").exit_game()

func _on_GroundCheck_body_entered(_body):
	is_on_ground = true

func _on_GroundCheck_body_exited(_body):
	is_on_ground = false
