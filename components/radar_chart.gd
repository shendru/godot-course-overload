extends Control

@export var stats: Stats

@export var stat_names := [
	"Health", "Armor", "Might", "Crit", "Speed"
]

@export var max_values := {
	"Health": 150,
	"Armor": 4,
	"Might": 2,
	"Crit": 25,
	"Speed": 260
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
		clamp(new_stats.armor / max_values["Armor"], 0, 1),
		clamp(new_stats.might / max_values["Might"], 0, 1),
		clamp(new_stats.luck / max_values["Crit"], 0, 1), # Using `luck` field for Crit
		clamp(new_stats.movement_speed / max_values["Speed"], 0, 1)
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

	# Smooth background circle
	draw_circle(center, radius + 12, bg_color)

	# Draw concentric rings
	for r in range(1, 6):
		var ring_radius = radius * (r / 5.0)
		draw_circle(center, ring_radius, ring_color)

	# Draw axes, labels, and radar points
	for i in range(count):
		var angle = angle_step * i - PI / 2
		var axis_end = center + Vector2(cos(angle), sin(angle)) * radius
		draw_line(center, axis_end, axis_color, 1)

		var label_text = stat_names[i]
		var label_pos = center + Vector2(cos(angle), sin(angle)) * (radius + 22)
		var label_size = font.get_string_size(label_text)
		draw_string(font, label_pos - label_size / 2, label_text)

		var value = stat_values[i]
		var point = center + Vector2(cos(angle), sin(angle)) * radius * value
		points.append(point)

		draw_circle(point, 4, dot_color)

	# Draw radar shape
	if points.size() > 2:
		draw_colored_polygon(points, stat_fill)
		draw_polyline(points + [points[0]], stat_border, 2)
