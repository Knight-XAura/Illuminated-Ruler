extends CanvasLayer

@onready var experience_bar: ProgressBar = $MarginContainer/VBoxContainer/ExperienceBar
@onready var health: Label = $MarginContainer/VBoxContainer/HBoxContainer/Health
@onready var level: Label = $MarginContainer/VBoxContainer/HBoxContainer/Level
@onready var time: Label = $MarginContainer/VBoxContainer/HBoxContainer/Time

var time_passed: float:
	set(value):
		time_passed = value
		time.text = "Time: %s" % [format_seconds(time_passed)]

func _process(delta: float) -> void:
	time_passed += delta


func format_seconds(unformatted_time : float) -> String:
	var minutes: float = unformatted_time / 60
	var seconds: float = fmod(unformatted_time, 60)
	return "%01d:%02d" % [minutes, seconds]
