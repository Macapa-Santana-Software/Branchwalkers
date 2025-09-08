extends CharacterBody2D

# ----------------- AJUSTE FINO -----------------
const MAX_GROUND_SPEED := 200.0
const MAX_AIR_SPEED    := 150.0      # limite horizontal no ar
const ACCEL_GROUND     := 1500.0     # aceleração no chão
const DECEL_GROUND     := 2500.0     # desaceleração no chão
const ACCEL_AIR        := 500.0      # aceleração no ar
const AIR_DRAG         := 120.0      # “freio” no ar
const JUMP_VELOCITY    := -400.0
# -----------------------------------------------

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Pulo (apenas se no chão)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Entrada horizontal
	var direction := Input.get_axis("ui_left", "ui_right") # -1..1

	# Estado atual
	var on_floor := is_on_floor()

	# >>> CORREÇÃO DO TERNÁRIO <<<
	var max_speed := MAX_GROUND_SPEED if on_floor else MAX_AIR_SPEED
	var accel := ACCEL_GROUND if on_floor else ACCEL_AIR
	# >>> FIM CORREÇÃO <<<

	# Define velocidade horizontal
	var target_speed := direction * max_speed

	if direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, accel * delta)
		animation.scale.x = sign(direction)
	else:
		if on_floor:
			velocity.x = move_toward(velocity.x, 0.0, DECEL_GROUND * delta)
		else:
			var s := AIR_DRAG * delta
			if abs(velocity.x) <= s:
				velocity.x = 0.0
			else:
				velocity.x -= sign(velocity.x) * s

	# Animações
	if not on_floor:
		animation.play("jump")
	elif abs(velocity.x) > 1.0:
		animation.play("run")
	else:
		animation.play("idle")

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		queue_free()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
