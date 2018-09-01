extends PopupPanel

signal standoff
signal standoff_ready
signal reset_signal
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Standoff.visible = false
	for player in global.scores:
		var container = preload("res://screens/game_screen/PlayerContainerDeath.tscn").instance()
		container.p_name = player
		container.name = player
		var i = load("res://actors/"+global.species[global.chosen_species[player]]+"_ship.png")
		for life in global.scores[player]:
			var l = load("res://screens/game_screen/life_rect.tscn").instance()
			l.set_texture(i)
			container.get_node("NinePatchRect/HBoxContainer").add_child(l)
		$VBoxContainer.add_child(container)
	connect("reset_signal", get_node('/root/Arena'), "reset")
	$close_button.disabled = true
	

# TODO: that timeout has to be an animation
func update_score():
	$Standoff.visible = false
	var guys = $VBoxContainer.get_children()
	yield(get_tree().create_timer(0.5), "timeout")
	var lives = 0
	for player in guys:
		lives = player.get_life_count()
		while(global.scores[player.p_name] < lives):
			player.remove_life()
			lives = player.get_life_count()
		yield(get_tree().create_timer(0.1), "timeout")

	if global.standoff:
		$Standoff.visible = true
		ready_for_standoff()
		print("getting ready")
		yield(self, "standoff_ready")
		global.gameover = false
		global.standoff = false
		
	$close_button.disabled=false
	$close_button.grab_focus()

func ready_for_standoff():
	var i = 0
	yield(get_tree().create_timer(0.7), "timeout")
	for player in global.scores:
		var container = $VBoxContainer.get_child(i)
		print(container.name)
		yield(get_tree().create_timer(0.1), "timeout")
		container.add_life()
		global.scores[player] += 1 
		i+=1
	emit_signal("standoff_ready")
	
func _on_close_button_pressed():
	get_tree().paused=false
	hide()
	if global.gameover:
		get_tree().change_scene_to(load('res://screens/gameover_screen/GameOver.tscn'))
	else:
		emit_signal("reset_signal")


func _on_Timer_timeout():
	print("dsa")
	