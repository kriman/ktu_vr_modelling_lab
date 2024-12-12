extends StaticBody3D

@onready var shrine_audio_player = get_node("/root/main/audio/shrine_blessing_sound")


var PRAISED = false
var INTERACTION_ENABLED = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_interaction_enabled(value: bool) -> void:
	INTERACTION_ENABLED = value

func interact() -> void:
	var text = "Praying at %s" % get_meta("name")
	Global.update_disappearing_label2(text)
	shrine_audio_player.play()
	if INTERACTION_ENABLED:
		PRAISED = true
		Global.checkAllPraised()
