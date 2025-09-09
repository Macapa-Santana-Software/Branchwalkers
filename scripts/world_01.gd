extends Node2D

@onready var player     : CharacterBody2D = $player
@onready var camera     : Camera2D        = $camera
@onready var terminal   : Control         = $Hub/Terminal
@onready var input_line : LineEdit        = $Hub/Terminal/Center/Panel/VBox/PromptRow/Input
@onready var output     : RichTextLabel   = $Hub/Terminal/Center/Panel/VBox/Output
@onready var quit_button: Button          = $Hub/Terminal/Center/Panel/Button

func _ready() -> void:
	player.follow_camera(camera)

	# botão Sair → fecha terminal
	if not quit_button.is_connected("pressed", Callable(self, "_close_terminal")):
		quit_button.connect("pressed", Callable(self, "_close_terminal"))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_terminal"):
		if terminal.visible:
			_close_terminal()
		else:
			_open_terminal()
	# (opcional) ESC fecha também
	elif event.is_action_pressed("ui_cancel") and terminal.visible:
		_close_terminal()

func _open_terminal() -> void:
	terminal.visible = true
	get_tree().paused = true
	input_line.clear()
	input_line.grab_focus()

func _close_terminal() -> void:
	# limpa digitado (e, se quiser, também o histórico)
	input_line.clear()
	# output.clear()  # descomente para limpar o histórico ao sair

	terminal.visible = false
	get_tree().paused = false

	
