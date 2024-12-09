extends Node2D

class_name Security

@export var decision_timer: Timer
@export var entries: Array
@export var secrets: Array
@export var office_index: int

signal activate_camera(cam_index: int, room_to: int)
signal stress_gauge_changed(stress: int)

var can_camera_stun: bool
var cameras: Array
var cameras_room: Array
var cameras_next: Array
var cameras_rects: Array
var stress_gauge: int

func _ready():
	stress_gauge = 0
	can_camera_stun = false
	cameras_room = Array()
	
	cameras_rects = Array()
	cameras_rects.append(Rect2())
	cameras_rects.append(Rect2())
	cameras_rects.append(Rect2())
	
	cameras_next = Array()
	cameras_next.append(Array())
	cameras_next.append(Array())
	cameras_next.append(Array())
	
	var index: int = 0
	cameras = Array()
	for child: Node in get_children():
		if child.name.contains('Camera'):
			var cam: Area2D = child as Area2D
			
			cameras_room.append(-1)
			cameras.append(cam)
			cam.body_entered.connect(func (body: Node2D):
				found_animatronic(body, index))
			index += 1

func edit_camera(rect: Rect2, cam_index: int, room_index):
	var camera: Area2D = cameras[cam_index] as Area2D
	var camera_collision: CollisionShape2D = camera.get_child(0) as CollisionShape2D
	
	camera_collision.shape.size = rect.size
	camera.position = rect.position - (position - rect.size * 0.5)
	
	cameras_rects[cam_index] = Rect2(rect.position - position, rect.size)
	cameras_room[cam_index] = room_index
	
	queue_redraw()

func found_animatronic(body: Node2D, cam_index: int):
	if body.is_class('CharacterBody2D'):
		update_stress_gauge(20)
		
		if cameras_room[cam_index] in entries or can_camera_stun:
			var animatronic: Animatronic = body as Animatronic
			animatronic.begin_stun()

func update_stress_gauge(value: int):
	stress_gauge += value
	if stress_gauge > 100:
		stress_gauge = 100
		
	stress_gauge_changed.emit(stress_gauge)
		
	match stress_gauge:
		20:
			decision_timer.wait_time /= 2
		80:
			activate_camera.emit(2, entries[0])
		100:
			can_camera_stun = true
		
func decision_single_camera(rooms_graph: Array, cam_index: int) -> int:
	var room_index: int = randi_range(0, cameras_next[cam_index].size()-1)
	var room: int = cameras_next[cam_index][room_index]
	
	select_camera_next(rooms_graph, cam_index, room)
	
	return room

func select_camera_next(rooms_graph: Array, cam_index: int, room: int):
	cameras_next[cam_index].clear()
	
	for i in range(rooms_graph.size()):
		if rooms_graph[room][i] != 0 and i != office_index and not i in secrets:
			cameras_next[cam_index].append(i)
			
func setup_camera(cam_index: int, rooms_graph: Array, room_to: int, room_rect: Rect2):
	cameras[cam_index].monitoring = true
	
	select_camera_next(rooms_graph, cam_index, room_to)
	edit_camera(room_rect, cam_index, room_to)

func _draw():
	for r: Rect2 in cameras_rects:
		var c: Color = Color(Color.WHITE, 0.3)
		draw_rect(r, c)
