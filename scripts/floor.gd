extends CollisionShape3D

@onready var collision_audio_player = get_node("/root/main/bust/collision_sound")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bust_body_entered(body: Node) -> void:
	collision_audio_player.play()
