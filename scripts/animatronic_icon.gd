extends HBoxContainer

class_name AnimatronicIcon

@export var texture_button: TextureButton
@export var progress_bar: ProgressBar
@export var timer: Timer

var is_progressing: bool

func _ready():
	timer_timeout()
	timer.timeout.connect(timer_timeout)

func _process(_delta):
	if is_progressing:
		progress_bar.value = timer.time_left

func begin_timer(time: float):
	timer.wait_time = time
	timer.start()
	
	is_progressing = true
	progress_bar.max_value = time
	progress_bar.modulate = Color(1, 1, 1, 1)
	
func timer_timeout():
	is_progressing = false
	progress_bar.modulate = Color(1, 1, 1, 0)
