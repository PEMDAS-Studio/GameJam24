extends Control

@onready var karmic_label = $MarginContainer/VBoxContainer/Text/HBoxContainer/KarmicLabel
@onready var karmic_level = $MarginContainer/VBoxContainer/Text/HBoxContainer/KarmicLevel
@onready var spread_label = $MarginContainer/VBoxContainer/Text/HBoxContainer2/SpreadLabel
@onready var spread_level = $MarginContainer/VBoxContainer/Text/HBoxContainer2/SpreadLevel
@onready var idea_text = $MarginContainer/VBoxContainer/Ideas/IdeaText
@onready var spread = $MarginContainer/VBoxContainer/Buttons/Spread
@onready var prevent = $MarginContainer/VBoxContainer/Buttons/Prevent
@onready var consequences_label = $Consequences/ConsequencesLabel
@onready var consequences = $Consequences

var isConsPanelOpen:bool = false

var karmicLevel:int = 0
var spreadLevel:int = 0
var currentIdea:int
var totalIdeas:int = 3
var ideas = [];
var spreadIdeas = [];

func _ready():
	load_ideas_json()
	karmic_level.text = str(karmicLevel)
	spread_level.text = "%" + str(spreadLevel)
	consequences_label.text = "You have no impact on the world!\nSpread your idea and check back here to see consequences."
	consequences.hide()
	randomIdea()


func load_ideas_json():
	var file = FileAccess.open("res://SpreadPlease/Scripts/ideas.json",  FileAccess.READ)
	ideas = JSON.parse_string(file.get_as_text())

func _process(delta):
	pass

func GetNextIdea(index:int):
	karmic_level.text = str(karmicLevel)
	spread_level.text = "%" + str(spreadLevel)
	idea_text.text = ideas[index]["text"]
	currentIdea = index

func randomIdea():
	var nextIdea = randi_range(0, totalIdeas-1)
	if spreadIdeas.find(nextIdea) != -1:
		if (spreadIdeas.size() >= ideas.size()):
			return
		randomIdea()
		return
	GetNextIdea(nextIdea)


func _on_spread_pressed():
	karmicLevel += ideas[currentIdea]["accepted_karmic_value"]
	spreadLevel += ideas[currentIdea]["accepted_spread_level"]
	consequences_label.text = ideas[currentIdea]["consequences"]
	spreadIdeas.push_front(currentIdea);
	randomIdea()


func _on_prevent_pressed():
	karmicLevel += ideas[currentIdea]["rejected_karmic_value"]
	spreadLevel += ideas[currentIdea]["rejected_spread_level"]
	randomIdea()


func _on_see_consequences_pressed():
	if isConsPanelOpen:
		consequences.hide()
		isConsPanelOpen = false
	else:
		consequences.show()
		isConsPanelOpen = true
