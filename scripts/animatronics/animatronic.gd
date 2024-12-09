extends CharacterBody2D

class_name Animatronic

@export var animatronic_data: AnimatronicData

@export_category('Animatronic Components')
@export var collision_shape_2d: CollisionShape2D
@export var move_timer: Timer
@export var stun_timer: Timer
@export var sprite_2d: Sprite2D
@export var texture_size_limit: Vector2
@export var stun_audio_stream_player: AudioStreamPlayer2D
@export var walk_audio_stream_player: AudioStreamPlayer2D
@export var walk_audios: Array

var speed: float
var next_position: Vector2
var next_rect: Rect2
var is_stunned: bool

func _ready():
	speed = 1
	is_stunned = false
	
	sprite_2d.texture = animatronic_data.character_sprite
	resize_texture()

func resize_texture():
	var texture_size: Vector2 = sprite_2d.texture.get_size()
	var ratio: Vector2 = texture_size_limit / texture_size
	sprite_2d.set_scale(ratio)

func move_to_next_room(room_to: int, dist: float, room_center_position: Vector2, room_rect: Rect2):	
	move_timer.wait_time = dist * speed
	move_timer.start()
	
	next_position = room_center_position
	next_rect = room_rect
	animatronic_data.room = room_to
	
	await move_timer.timeout
	
	if is_stunned:
		return
	
	position = next_position + animatronic_data.position_offset
	edit_collision_shape(next_rect)
	
	play_walk_sound()
	
func edit_collision_shape(rect: Rect2):
	collision_shape_2d.position = Vector2.ZERO
	
	collision_shape_2d.shape.size = rect.size
	collision_shape_2d.position -= animatronic_data.position_offset

func begin_stun():
	is_stunned = true
	stun_timer.start()
	
	play_stun_sound()
	
func play_stun_sound():
	stun_audio_stream_player.play()
	
func play_walk_sound():
	var i: int = randi_range(0, walk_audios.size()-1)
	var audio: AudioStreamMP3 = walk_audios[i]
	
	walk_audio_stream_player.stream = audio
	walk_audio_stream_player.play()
