extends Control

class_name Icons

@export var icons_texture_size_limit: Vector2

var animatronics_icons: Array

func _ready():
	animatronics_icons = Array()
	
	for animatronic_icon: AnimatronicIcon in get_child(0).get_children():
		animatronics_icons.append(animatronic_icon)
		
		var button_rect: Rect2 = animatronic_icon.texture_button.get_rect()
		var ratio: Vector2 = icons_texture_size_limit / button_rect.size
		
		animatronic_icon.texture_button.set_scale(ratio)

func update_texture(normal: Texture, hover: Texture, index: int):
	var animatronic_icon: AnimatronicIcon = animatronics_icons[index] as AnimatronicIcon
	
	animatronic_icon.texture_button.texture_normal = normal
	animatronic_icon.texture_button.texture_hover = hover

func begin_progress(index: int, time: float):
	var animatronic_icon: AnimatronicIcon = animatronics_icons[index] as AnimatronicIcon
	animatronic_icon.begin_timer(time)
