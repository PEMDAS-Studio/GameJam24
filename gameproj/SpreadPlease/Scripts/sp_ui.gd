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
var ideas = {
	1:{
		"text": "You need to give half of your money to people in need.",
		"accepted_karmic_value": 60,
		"rejected_karmic_value": -5,
		"accepted_spread_level": -20,
		"rejected_spread_level": 0,
		"consequences": "Powerty level is decreasing, capitalist are mad at you."
	},
	2:{
		"text": "You can kill old people if it's beneficial to you.",
		"accepted_karmic_value": -60,
		"rejected_karmic_value": 30,
		"accepted_spread_level": 10,
		"rejected_spread_level": 10,
		"consequences": "Capitalist are thriving, you are powerful in man-power"
	},
	3:{
		"text": "You can't drink alcohol while pregnant ",
		"accepted_karmic_value": 30,
		"rejected_karmic_value": -30,
		"accepted_spread_level": -10,
		"rejected_spread_level": 10,
		"consequences": "Child deaths and at-birth complications are decreasing."
	}
}

func _ready():
	karmic_level.text = str(karmicLevel)
	spread_level.text = "%" + str(spreadLevel)
	consequences_label.text = "You have no impact on the world!\nSpread your idea and check back here to see consequences."
	consequences.hide()
	GetNextIdea(1)



func _process(delta):
	pass

func GetNextIdea(index:int):
	karmic_level.text = str(karmicLevel)
	spread_level.text = "%" + str(spreadLevel)
	idea_text.text = ideas[index]["text"]
	currentIdea = index


func _on_spread_pressed():
	karmicLevel += ideas[currentIdea]["accepted_karmic_value"]
	spreadLevel += ideas[currentIdea]["accepted_spread_level"]
	consequences_label.text = ideas[currentIdea]["consequences"]
	var nextIdea = randi_range(1, totalIdeas)
	GetNextIdea(nextIdea)


func _on_prevent_pressed():
	karmicLevel += ideas[currentIdea]["rejected_karmic_value"]
	spreadLevel += ideas[currentIdea]["rejected_spread_level"]
	var nextIdea = randi_range(1, totalIdeas)
	GetNextIdea(nextIdea)


func _on_see_consequences_pressed():
	if isConsPanelOpen:
		consequences.hide()
		isConsPanelOpen = false
	else:
		consequences.show()
		isConsPanelOpen = true
