extends Node2D

class_name Night

var rooms_graph: Array
var rooms_rect: Array
var rooms: Array
var animatronics: Array
var security: Security
var time_label: Label

var selected_animatronic: int
var is_selecting: bool
var icons: Icons
var current_time: int
var stress_gauge: ProgressBar

func _ready():
	selected_animatronic = -1
	is_selecting = false
	current_time = 0
	
	build_graph()

	animatronics = Array()
	rooms = Array()
	rooms_rect = Array()
	
	for child: Node in get_children():
		match child.name:
			'Rooms':
				setup_rooms(child)
			'Animatronics':
				setup_animatronics(child)
			'Icons':
				setup_icons(child)
			'Security':
				setup_security(child)
			'TimeLabel':
				time_label = child as Label
			'StressGauge':
				setup_stress_gauge(child)

func build_graph():
	rooms_graph = [
		[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # ClassicShowStage
		[1,0,2,0,2,2,0,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # DiningArea
		[0,2,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Backstage
		[0,0,2,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Funtime Bunker
		[0,2,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Ships Cove
		[0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Bathrooms
		[0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Safe Room
		[0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Alleyway 
		[0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,2,0,0,0,1,0,0,0,0,0,0,0,0,2], # LeftHall
		[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Supply Room
		[0,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,2], # Right Hall
		[0,2,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Kitchen
		[0,0,0,0,0,0,0,0,0,0,2,2,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Spare Room 1
		[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Spare Storage 1
		[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Spare Stand 1
		[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], # Spare Stage 1
		[0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0], # Spare Room 2
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0], # Spare Storage 2
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0], # Spare Stand 2
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0], # Spare Stage 2
		[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0], # Left Party Room
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0], # Mediocre Stand
		[0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0], # Right Party Room
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0], # Rockband
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,2,2,0,1,0], # Game Area
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0], # Rich Bank
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0], # Parts Services
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0], # Nightmare Storage
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0], # Toy Show Stage
		[0,0,0,0,0,0,0,0,2,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  # TheOffice
	]

func setup_rooms(node: Node):
	for room: Button in node.get_children():
		rooms.append(room)
		rooms_rect.append(room.get_rect())
		room.pressed.connect(func():
			room_selected(room.get_index()))

func setup_animatronics(node: Node):
	for animatronic_body: CharacterBody2D in node.get_children():
		animatronics.append(animatronic_body)
		var animatronic: Animatronic = animatronic_body as Animatronic
		var room_to: int = animatronic.animatronic_data.spawn_room
		animatronic.stun_timer.timeout.connect(func ():
			stun_ended(animatronic.get_index()))
		animatronic.move_to_next_room(room_to, 0.1, get_room_center_position(room_to), rooms_rect[room_to])
		
func setup_icons(node: Node):
	icons = node as Icons
	
	for index in range(icons.animatronics_icons.size()):
		var data: AnimatronicData = animatronics[index].animatronic_data as AnimatronicData
		var icon: AnimatronicIcon = icons.animatronics_icons[index] as AnimatronicIcon
		
		icons.update_texture(data.icon_normal, data.icon_hover, index)
		icon.texture_button.pressed.connect(func():
			animatronic_selected(index))

func setup_security(node: Node):
	security = node as Security
	security.decision_timer.timeout.connect(security_decision)
	security.activate_camera.connect(on_activate_camera)

	security.position = get_room_center_position(security.office_index)
	security.activate_camera.emit(0, security.entries[0])
	security.activate_camera.emit(1, security.entries[1])

func setup_stress_gauge(node: Node):
	stress_gauge = node.get_child(0).get_child(1) as ProgressBar
	security.stress_gauge_changed.connect(on_stress_gauge_changed)

func animatronic_selected(anim_index: int):
	var animatronic: Animatronic = animatronics[anim_index]
	if animatronic.is_stunned:
		return
	
	selected_animatronic = anim_index
	is_selecting = true

func room_selected(room_to: int):
	if not is_selecting:
		return
		
	is_selecting = false
		
	var animatronic: Animatronic = animatronics[selected_animatronic] as Animatronic
	var room_from: int = animatronic.animatronic_data.room
	var dist: float = rooms_graph[room_from][room_to]
	
	if dist == 0:
		return
		
	icons.begin_progress(selected_animatronic, dist)
	
	await animatronic.move_to_next_room(room_to, dist, get_room_center_position(room_to), rooms_rect[room_to])
	if room_to == security.office_index and not animatronic.is_stunned:
		reached_security() 

func stun_ended(animatronic_index: int):
	var animatronic: Animatronic = animatronics[animatronic_index] as Animatronic
	var room_to: int = animatronic.animatronic_data.spawn_room
	animatronic.is_stunned = false
	animatronic.move_to_next_room(room_to, 0.1, get_room_center_position(room_to), rooms_rect[room_to])

func get_room_center_position(room_to: int) -> Vector2:
	var room_rect: Rect2 = rooms_rect[room_to] as Rect2
	return room_rect.position + room_rect.size * 0.5

func on_activate_camera(cam_index: int, room_to: int):
	security.setup_camera(cam_index, rooms_graph, room_to, rooms_rect[room_to])

func on_stress_gauge_changed(stress: int):
	stress_gauge.value = stress

func security_decision():
	for i in range(security.cameras.size()):
		var cam: Area2D = security.cameras[i] as Area2D
		if cam.monitoring:
			var room_index: int = security.decision_single_camera(rooms_graph, i)
			security.edit_camera(rooms_rect[room_index], i, room_index)

func reached_security():
	get_tree().change_scene_to_file("res://scenes/victory.tscn")
	
func night_over():
	get_tree().change_scene_to_file("res://scenes/defeat.tscn")
	
func night_timer_timeout():
	current_time += 1
	time_label.text = '0{0}:00'.format([current_time])
	if current_time == 6:
		night_over()
