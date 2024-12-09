extends Control

class_name MainMenu

@export var dir_light: DirectionalLight2D
@export var light_timer: Timer
@export var light_buzz_audio: AudioStreamPlayer2D

func _ready():
	light_timer.wait_time = pick_time()
	light_timer.start()
	
func pick_time() -> float:
	return randf()
	
func light_timer_timeout():
	light_timer.wait_time = pick_time()
	dir_light.enabled = not dir_light.enabled
	
	if not dir_light.enabled:
		light_buzz_audio.play()
	else:
		light_buzz_audio.stop()

func play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/night.tscn")
	
func exit_button_pressed():
	get_tree().quit()
