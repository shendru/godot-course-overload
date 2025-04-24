extends CanvasLayer

signal transition_completed

@onready var fade: ColorRect = $Fade

func fade_out(duration := 0.5):
	show()
	fade.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, duration)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _on_fade_out_complete():
	emit_signal("transition_completed")

func fade_in(duration := 0.5):
	fade.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, duration)
