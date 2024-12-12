extends RigidBody3D


var enabled = false
var is_in_contact = true
var first_contact = true
@onready var collision_audio_player = $collision_sound
@onready var claim_sound = $claim_sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var num_contact = get_contact_count()
	
	if num_contact == 1:
		# on ground
		if not is_in_contact and not first_contact:
			collision_audio_player.play()
		is_in_contact = true
		first_contact = false
	elif num_contact == 0:
		if is_in_contact:
			is_in_contact = false
	


func _on_checkpoint_body_entered(body: Node3D) -> void:
	if enabled and body == self:
		claim_sound.play()
		self.visible = false
		Global.end_q3()


func interact() -> void:
	pass
