extends Node

@onready var next_quest_audio_player = get_node("/root/main/next_quest_sound")
@onready var shrines = get_tree().get_nodes_in_group("shrines")
@onready var checkpoints = get_tree().get_nodes_in_group("checkpoints")
@onready var gate = get_node("/root/main/level0_ground/gate")
@onready var exit = get_node("/root/main/level0_ground/exit")
@onready var bust = get_node("/root/main/level0_ground/bust")
@onready var label = get_node("/root/main/Control/Label")
@onready var disa1 = get_node("/root/main/Control/Disa1")
@onready var disa2 = get_node("/root/main/Control/Disa2")
@onready var timer = get_node("/root/main/Control/Timer")


enum QUEST_STATUS {ACTIVE, COMPLETED, HIDDEN}

var quest_list = [
	"Explore the garden", # check all 4 checkpoints
	"Prayers", # pray at all 3 shrines
	"Sacrafice", # take the bust to the statue
	"Salvation" # leave the garden
]

var quests = {
	"Explore the garden": QUEST_STATUS.ACTIVE,
	"Prayers": QUEST_STATUS.HIDDEN,
	"Sacrafice": QUEST_STATUS.HIDDEN,
	"Salvation": QUEST_STATUS.HIDDEN
}

func get_current_quest() -> String:
	for quest_name in quest_list:
		if quests[quest_name] == QUEST_STATUS.ACTIVE:
			return quest_name
	return ""

func end_quest(current_quest: String) -> void:
	if quests[current_quest] != QUEST_STATUS.ACTIVE:
		return
	
	update_quest_ui_end(current_quest)
	
	quests[current_quest] = QUEST_STATUS.COMPLETED
	var new_quest_idx = quest_list.find(current_quest) + 1
	if new_quest_idx == len(quest_list):
		return
	var new_quest = quest_list[new_quest_idx]
	quests[new_quest] = QUEST_STATUS.ACTIVE
	update_quest_ui()

func update_disappearing_label(text: String) -> void:
	disa1.text = text
	disa1.visible = true
	timer.start()

func update_disappearing_label2(text: String) -> void:
	disa2.text = text
	disa2.visible = true
	timer.start()

func update_quest_ui_end(prev_quest: String) -> void:
	next_quest_audio_player.play()
	
	var text = "Quest finished: %s" % prev_quest
	print(text)
	update_disappearing_label(text)

func update_quest_ui() -> void:
	var text = "New quest: %s" % get_current_quest()
	label.visible = true
	label.text = text


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_quest_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	cheats()
	
	if Input.is_action_just_pressed("ui_fullscreen"):
		print(DisplayServer.window_get_mode()	)
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func checkAllPraised() -> void:
	var all_praised = true
	for shrine in shrines:
		if not shrine.PRAISED:
			all_praised = false
			break
	if all_praised:
		end_q2()

func checkAllVisited() -> void:
	var all_visited = true
	for checkpoint in checkpoints:
		if not checkpoint.CHECKED_IN:
			all_visited = false
			break
	if all_visited:
		end_q1()

func set_shrines(value: bool) -> void:
	for shrine in shrines:
		shrine.set_interaction_enabled(value)

func end_q1() -> void:
	Global.set_shrines(true)
	Global.end_quest("Explore the garden")

func end_q2() -> void:
	Global.end_quest("Prayers")
	bust.enabled = true

func end_q3() -> void:
	Global.end_quest("Sacrafice")
	gate.visible = false
	exit.enabled = true

func end_q4() -> void:
	Global.end_quest("Salvation")
	label.text = "END"


func cheats() -> void:
	if Input.is_action_just_pressed("skipq1"):
		end_q1()
	elif Input.is_action_just_pressed("skipq2"):
		end_q2()
	elif Input.is_action_just_pressed("skipq3"):
		end_q3()
	elif Input.is_action_just_pressed("skipq4"):
		end_q4()
