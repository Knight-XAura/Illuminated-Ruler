extends CanvasLayer

@onready var experience_bar: ProgressBar = $MarginContainer/VBoxContainer/ExperienceBar
@onready var health: Label = $MarginContainer/VBoxContainer/HBoxContainer/Health
@onready var level: Label = $MarginContainer/VBoxContainer/HBoxContainer/Level
@onready var time: Label = $MarginContainer/VBoxContainer/HBoxContainer/Time
@onready var game_over_n_credits: VBoxContainer = $GameOverNCredits


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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action") and game_over_n_credits.visible == true:
		get_tree().reload_current_scene()
		

func _on_roy_health_changed(current: int, max: int) -> void:
	health.text = "Health: %s/%s" % [current, max]


func _on_roy_leveled_up(new_level: int) -> void:
	level.text = "LVL: %s" % [new_level]


func _on_roy_gained_experience(gained_exp: int) -> void:
	experience_bar.value = gained_exp


func _on_roy_died() -> void:
	game_over_n_credits.show()
