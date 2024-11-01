extends RayCast3D

var current_collider = null
var held_object = null

@onready var level = get_node("/root/main/level0_ground")
@onready var interaction_label = get_node("/root/main/Control/Interaction_label")
@onready var hold_pos = get_node("../Hold_pos")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collider = get_collider()
	
	if collider != current_collider:
		current_collider = collider

		if collider and collider.is_in_group("interactable"):
			var text = "Press [E] to interact with %s" % collider.get_meta("name")
			interaction_label.text = text
			interaction_label.visible = true
		else:
			interaction_label.visible = false

	if Input.is_action_just_pressed("game_action"):
		item_interact(collider)
		interact(collider)

func interact(collider) -> void:
	if collider and collider.is_in_group("interactable"):
		collider.interact()


func item_interact(collider) -> void:
	if collider and collider.is_in_group("pickupable"):
		if not held_object:
			pickup(collider)
	elif held_object:
		drop()


func pickup(collider) -> void:
	held_object = collider
	held_object.reparent(self)
	held_object.global_transform.origin = hold_pos.global_transform.origin
	held_object.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	held_object.freeze = true
	held_object.set_collision_layer(0)

func drop() -> void:
	held_object.set_collision_layer(1)
	held_object.reparent(level)
	held_object.freeze = false
	held_object = null
