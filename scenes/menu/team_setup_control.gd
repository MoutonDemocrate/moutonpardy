extends PanelContainer
class_name TeamSetupControl

@export var number_label: Label
@export var team_name_edit: LineEdit
@export var color_button: ColorPickerButton
@export var kill_button: Button

const SCENE := preload("res://scenes/menu/team_setup_control.tscn")

const adjective: Array[String] = ["Sentient", "Superb", "Overachieving", "Magnificent", "Powerful", "Electronic", "Absolute", "Super", "Hyper", "Mega", "Rainbow"]
const nouns: Array[String] = ["Bits Of Metal", "Brocolis", "Creatures", "Monsters", "Beasts", "Talents", "Heroes", "Fruits", "Magicians", "Carabiners", "Bits Of Plastic", "Microplastics", "Bugs", "Cats"]

static func create() -> TeamSetupControl:
	var team_control: TeamSetupControl = SCENE.instantiate()
	return team_control

func _ready() -> void:
	number_label.text = str(self.get_index())
	team_name_edit.text = (
		("The " if randf() > 0.3 else "") +
		adjective.pick_random() + " " +
		nouns.pick_random()
	)
	var random_color := Color.from_hsv(randf(), 1.0, 1.0)
	color_button.color = random_color
	self_modulate = random_color
	kill_button.pressed.connect(self.queue_free)
	color_button.color_changed.connect(
		func (col:Color) -> void:
			self.self_modulate = col
	)
