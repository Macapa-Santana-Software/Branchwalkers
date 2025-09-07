extends Node2D

@onready var player := $player as CharacterBody2D
@onready var camera := $camera as Camera2D
@onready var terminal = $Terminal

func _ready():
	player.follow_camera(camera)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_terminal"):
		_toggle_terminal()


func _toggle_terminal() -> void:
	var show: bool = not terminal.visible
	terminal.visible = show
	get_tree().paused = show   # pausa o jogo quando terminal abre

	if show:
		terminal.get_node("Panel/VBoxContainer/LineEdit").grab_focus()


func _on_button_pressed() -> void:
	var visible = false
	get_tree().paused = false
