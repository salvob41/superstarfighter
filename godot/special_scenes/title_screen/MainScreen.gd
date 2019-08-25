extends BasicScreen

# TODO: We need a way to get the scene
onready var title = $TitleScreen
onready var options = $Options

export var multiplayer_scene : PackedScene

func _on_QuitButton_pressed():
	get_tree().quit()

func _ready():
	# TranslationServer.set_locale("es")
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	remove_child(options)
	
func _on_TitleScreen_option_selected():
	remove_child(title)
	add_child(options)
	options.enable_all()


func _on_Options_back():
	add_child(title)
	remove_child(options)
	title.initialize()


func _on_TitleScreen_start_multiplayer():
	switch()
	yield(self, "finished")
	get_tree().change_scene_to(multiplayer_scene)