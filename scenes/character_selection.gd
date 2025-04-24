extends Control

# Declare the stats resources
@export var IT_CHARA: PlayerChara
@export var IS_CHARA: PlayerChara
@export var CA_CHARA: PlayerChara
@export var CS_CHARA: PlayerChara

@export var IT_STATS: Stats
@export var IS_STATS: Stats
@export var CA_STATS: Stats
@export var CS_STATS: Stats



@onready var character_preview = $CharacterSelection/CharacterPreview
@onready var course_label: RichTextLabel = $CharacterSelection/CourseLabel
@onready var course_description: RichTextLabel = $CharacterSelection/CourseDiscription


@onready var health_bar = $CharacterSelection/StatsPanel/HEALTH
@onready var speed_bar = $CharacterSelection/StatsPanel/SPEED

@onready var radar_chart = $CharacterSelection/StatsPanel/RadarChart

@onready var character_buttons = {
	"IT": $CharacterSelection/HBoxContainer/IT_CHARACTER,
	"IS": $CharacterSelection/HBoxContainer/IS_CHARACTER,
	"CA": $CharacterSelection/HBoxContainer/CA_CHARACTER,
	"CS": $CharacterSelection/HBoxContainer/CS_CHARACTER
}

var charcter_animation: SpriteFrames
var main_weapon: Resource
var current_stats: Stats
var current_player_chara: PlayerChara

var availability: bool = false


func _ready():
	var buttons = [
		{"node": "CharacterSelection//HBoxContainer/IT_CHARACTER", "signal": _on_IT_CHARACTER_pressed},
		{"node": "CharacterSelection//HBoxContainer/IS_CHARACTER", "signal": _on_IS_CHARACTER_pressed},
		{"node": "CharacterSelection//HBoxContainer/CA_CHARACTER", "signal": _on_CA_CHARACTER_pressed},
		{"node": "CharacterSelection//HBoxContainer/CS_CHARACTER", "signal": _on_CS_CHARACTER_pressed},
		{"node": "CharacterSelection/Start", "signal": _on_Start_pressed}
	]

	for button in buttons:
		var btn = get_node(button["node"])
		btn.pressed.connect(button["signal"])

	print("Hello World")
	
func grey_out_others(selected_key: String):
	var main_tween = create_tween()
	main_tween.set_parallel()

	for key in character_buttons:
		var texture_rect = character_buttons[key].get_node("TextureRect")
		var is_selected = (key == selected_key)

		var target_color = Color(1, 1, 1) if is_selected else Color(0.5, 0.5, 0.5)
		var target_scale = Vector2(1, 1) if is_selected else Vector2(0.9, 0.9)

		# Color transition (for all)
		main_tween.tween_property(
			texture_rect,
			"modulate",
			target_color,
			0.2
		)

		if is_selected:
			# Use a separate tween for the pop animation
			var pop_tween = create_tween()
			pop_tween.tween_property(
				texture_rect,
				"scale",
				Vector2(1.1, 1.1),
				0.08
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

			pop_tween.tween_property(
				texture_rect,
				"scale",
				Vector2(1, 1),
				0.12
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
		else:
			# Others scale down smoothly
			main_tween.tween_property(
				texture_rect,
				"scale",
				target_scale,
				0.2
			)
		
		
func update_stats_ui(stats: Stats):
	var tween = create_tween().set_parallel()

	# Animate health and speed bars
	tween.tween_property(
		health_bar,
		"value",
		stats.max_health,
		0.3
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		speed_bar,
		"value",
		stats.movement_speed,
		0.3
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

# Functions to handle button press and assign stats to characters
func _on_IS_CHARACTER_pressed():
	#GameState.selected_stats = IS_STATS
	availability = false
	print("IS_CHARACTER clicked!")
	main_weapon = load("res://Resources/weapons temp/whip.tres")
	charcter_animation = load("res://animations/ITWolfFrames.tres")
	apply_character_stats(IS_STATS, IS_CHARA)
	update_character_preview(IS_CHARA.animated_sprite)  
	grey_out_others("IS")

func _on_IT_CHARACTER_pressed():
	#GameState.selected_stats = IT_STATS
	availability = true
	print("IT_CHARACTER clicked!")
	main_weapon = load("res://Resources/weapons temp/whip.tres")
	charcter_animation = load("res://animations/ITWolfFrames.tres")
	apply_character_stats(IT_STATS, IT_CHARA)
	update_character_preview(IT_CHARA.animated_sprite) 
	grey_out_others("IT")

func _on_CS_CHARACTER_pressed():
	#GameState.selected_stats = CS_STATS
	availability = false
	print("CS_CHARACTER clicked!")
	main_weapon = load("res://Resources/weapons temp/whip.tres")
	charcter_animation = load("res://animations/SlimeFrames.tres")
	apply_character_stats(CS_STATS, CS_CHARA)
	update_character_preview(CS_CHARA.animated_sprite)  
	grey_out_others("CS")

func _on_CA_CHARACTER_pressed():
	#GameState.selected_stats = CA_STATS
	availability = true
	print("CA_CHARACTER clicked!")
	main_weapon = load("res://Resources/weapons-experimental/Simple Wand.tres")
	charcter_animation = load("res://animations/CAWolfFrames.tres")
	
	apply_character_stats(CA_STATS, CA_CHARA)
	update_character_preview(CA_CHARA.animated_sprite) 
	grey_out_others("CA")

func _on_Start_pressed():
	print("Start clicked!")
	if current_stats and main_weapon and availability:
		# Store selections in GameState
		GameState.selected_chara = current_player_chara
		GameState.selected_stats = current_stats
		GameState.selected_weapon = main_weapon
		GameState.selected_player_animation = charcter_animation
		# Load level scene
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	else:
		print("Please select a character first!")

# Function to apply stats to the selected character
func apply_character_stats(stats: Stats, player_chara : PlayerChara):
	current_stats = stats
	current_player_chara = player_chara
	radar_chart.update_stat_values(stats)
	update_stats_ui(stats)
	
	course_label.text = player_chara.course_label
	course_description.text = player_chara.course_description

# Function to update the character preview texture
func update_character_preview(sprite_frames: SpriteFrames):
	var sprite = sprite_frames 
	character_preview.sprite_frames = sprite
	character_preview.update_anim()
	
#func update_character_preview(texture_path: String):
	#var texture = load(texture_path)  # Load the texture from the given path
	#character_preview.texture = texture  # Set the texture of the TextureRect


func _on_back_button_pressed() -> void:
	get_tree().quit()
