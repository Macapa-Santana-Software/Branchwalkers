extends Control

const PROMPT := "user@host:~$ "

@onready var output     : RichTextLabel = $Panel/VBoxContainer/RichTextLabel
@onready var input_line : LineEdit      = $Panel/VBoxContainer/LineEdit
@onready var quit_btn   : Button        = $Panel/Button

var checkpoint := 0

func _ready() -> void:
	# Aparência/qualidade de vida (opcional)
	output.scroll_following = true
	# Se quiser monoespaçada, configure pelo Inspector (fonte e tamanho) ou por código aqui.

	# Conecta ENTER do LineEdit (envio)
	if not input_line.is_connected("text_submitted", Callable(self, "_on_input_submitted")):
		input_line.connect("text_submitted", Callable(self, "_on_input_submitted"))

	# Fallback: captura Enter via gui_input (teclado numérico, etc.)
	if not input_line.is_connected("gui_input", Callable(self, "_on_input_gui_input")):
		input_line.connect("gui_input", Callable(self, "_on_input_gui_input"))

	# (Opcional) conectar botão sair aqui também, se preferir no Terminal:
	# if not quit_btn.is_connected("pressed", Callable(self, "_on_quit_pressed")):
	# 	quit_btn.connect("pressed", Callable(self, "_on_quit_pressed"))

	# Banner inicial
	_print_banner()

func _print_banner() -> void:
	output.clear()
	output.append_text("EduGit Terminal v0.1\n")
	output.append_text("Aprenda Git passo a passo.\n")
	output.append_text("Comandos disponíveis: git add\n")
	output.append_text("-------------------------------------------")

# --- envio via sinal text_submitted ---
func _on_input_submitted(text: String) -> void:
	_submit_command(text)

# --- envio via fallback (Enter pela GUI do LineEdit) ---
func _on_input_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			accept_event() # evita propagação indesejada
			_submit_command(input_line.text)

# --- lógica de envio/execução ---
func _submit_command(raw: String) -> void:
	var cmd := raw.strip_edges()

	# Linha sobe para o histórico com prompt
	output.append_text("\n" + PROMPT + cmd)

	# Limpa input
	input_line.clear()

	# Resposta
	match cmd:
		"git add":
			if checkpoint == 0:
				output.append_text("\n✔ Checkpoint 1: git add aprendido!")
				checkpoint = 1
			else:
				output.append_text("\n✔ Arquivos adicionados novamente.")
		"", " ":
			# nada digitado: só quebra a linha
			pass
		_:
			output.append_text("\n❌ Comando não reconhecido.")

	# volta foco no input (qualquer caso)
	input_line.grab_focus()

# (opcional) caso conecte o botão Sair ao Terminal em vez do world_01
func _on_quit_pressed() -> void:
	input_line.clear()
	# output.clear()  # descomente se quiser limpar histórico ao sair
	visible = false
	get_tree().paused = false
