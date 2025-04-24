extends Control

@export var stats: Stats

@export var stat_names := [
	"Health", "Recovery", "Armor", "Speed",
	"Might", "Area", "Magnet", "Growth",
	"Luck", "Haste", "Knockback"
]

@export var max_values := {
	"Health": 200.0,
	"Recovery": 10.0,
	"Armor": 10.0,
	"Speed": 20.0,
	"Might": 10.0,
	"Area": 5.0,
	"Magnet": 100.0,
	"Growth": 10.0,
	"Luck": 10.0,
	"Haste": 5.0,
	"Knockback": 5.0
}

var radius := 100.0
var stat_values: Array[float] = []

func _ready():
	if stats:
		update_stat_values(stats)
	queue_redraw()

func update_stat_values(new_stats: Stats):
	stat_values = [
		clamp(new_stats.max_health / max_values["Health"], 0, 1),
		clamp(new_stats.recovery / max_values["Recovery"], 0, 1),
		clamp(new_stats.armor / max_values["Armor"], 0, 1),
		clamp(new_stats.movement_speed / max_values["Speed"], 0, 1),
		clamp(new_stats.might / max_values["Might"], 0, 1),
		clamp(new_stats.attack_aoe / max_values["Area"], 0, 1),
		clamp(new_stats.magnet / max_values["Magnet"], 0, 1),
		clamp(new_stats.growth / max_values["Growth"], 0, 1),
		clamp(new_stats.luck / max_values["Luck"], 0, 1),
		clamp(new_stats.haste / max_values["Haste"], 0, 1),
		clamp(new_stats.weapon_knockback / max_values["Knockback"], 0, 1)
	]
	queue_redraw()
	
	
func _draw():
	if stat_values.is_empty():
		return

	var center := get_rect().size / 2
	var count := stat_values.size()
	var angle_step := TAU / count
	var font := get_theme_default_font()
	var points := []

	var bg_color := Color(0.1, 0.1, 0.1, 0.2)
	var axis_color := Color(0.7, 0.7, 0.7, 0.15)
	var ring_color := Color(0.2, 0.2, 0.2, 0.3)
	var stat_fill := Color(0.2, 0.85, 1.0, 0.35)
	var stat_border := Color(0.2, 0.85, 1.0, 0.9)
	var dot_color := Color(0.9, 0.95, 1, 0.8)
	var label_color := Color(0.9, 0.9, 0.9)

	# Smooth background circle (optional)
	draw_circle(center, radius + 12, bg_color)

	# Draw concentric rings (5 levels)
	for r in range(1, 6):
		var ring_radius = radius * (r / 5.0)
		draw_circle(center, ring_radius, ring_color)

	# Draw axes and labels
	for i in range(count):
		var angle = angle_step * i - PI / 2
		var axis_end = center + Vector2(cos(angle), sin(angle)) * radius
		draw_line(center, axis_end, axis_color, 1)

		# Label 
		var label_text = stat_names[i]
		var label_pos = center + Vector2(cos(angle), sin(angle)) * (radius + 22)
		var label_size = font.get_string_size(label_text)
		draw_string(font, label_pos - label_size / 2, label_text)

		# Radar point
		var value = stat_values[i]
		var point = center + Vector2(cos(angle), sin(angle)) * radius * value
		points.append(point)

		# Glowing dot at each stat point
		draw_circle(point, 4, dot_color)

	# Draw radar shape
	if points.size() > 2:
		draw_colored_polygon(points, stat_fill)
		draw_polyline(points + [points[0]], stat_border, 2)
