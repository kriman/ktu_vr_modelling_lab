extends Area3D

var enabled = false
@onready var sound = $whoosh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if enabled and body.is_in_group("players"):
		sound.play()
		Global.end_q4()
