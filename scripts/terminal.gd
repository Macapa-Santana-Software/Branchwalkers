extends Control

@onready var output = $Panel/VBoxContainer/RichTextLabel
@onready var input_line = $Panel/VBoxContainer/LineEdit

var checkpoint = 0

func _ready():
	top_level = true
	# Quando o jogador pressionar Enter no LineEdit, chamamos _on_command_entered
	input_line.connect("text_submitted", Callable(self, "_on_command_entered"))

func _on_command_entered(command: String) -> void:
	# Limpa a linha de input
	input_line.clear()

	# Adiciona o comando digitado ao output
	output.append_text("\n> " + command)

	# Verifica comandos
	match command.strip_edges():
		"git add":
			if checkpoint == 0:
				output.append_text("\n✔ Checkpoint 1: git add aprendido!")
				checkpoint = 1
			else:
				output.append_text("\n✔ Arquivos adicionados novamente.")
		_:
			output.append_text("\n❌ Comando não reconhecido.")
