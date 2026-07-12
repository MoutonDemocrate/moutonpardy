extends PanelContainer
class_name TeamPanel

@export var team_name_label: Label
@export var points_label: Label
@export var points_spinbox: SpinBox
@export var plus_button: Button
@export var minus_button: Button

## Name of the team
var team_name: String
## Current number of points of the team
var points: int
## Color of the team
var team_color: Color :
	set(new):
		team_color = new
		self.self_modulate = new
## [code]true[/true] if the team is in the lead
var leading: bool = false :
	set(new):
		leading = new
		if team_name_label:
			team_name_label.text = (LEADING_ICON + " " if new else "") + team_name

signal points_changed(new_points_amount:int)

const LEADING_ICON = "👑"
const SCENE := preload("res://scenes/game/team_panel.tscn")
const DEFAULT_POINTS_STEP := 100

static func from_team_name(new_team_name:String, color:Color = Color.WHITE) -> TeamPanel:
	var team_panel: TeamPanel = SCENE.instantiate()
	team_panel.team_name = new_team_name
	team_panel.team_name_label.text = new_team_name
	team_panel.team_color = color
	return team_panel

func _ready() -> void:
	set_points(0)
	leading = false
	points_label.show()
	points_spinbox.hide()

	points_spinbox.mouse_exited.connect(
		func () -> void:
			points_spinbox.hide()
			points_label.show()
	)
	points_spinbox.value_changed.connect(set_points)
	plus_button.pressed.connect(add_points.bind(DEFAULT_POINTS_STEP))
	minus_button.pressed.connect(remove_points.bind(DEFAULT_POINTS_STEP))

func set_points(new_points:int) -> void:
	print("Set team points of '", team_name, "' to ", new_points)
	points_label.text = str(new_points)
	points = new_points
	points_spinbox.set_value_no_signal(new_points)
	points_changed.emit(new_points)

func add_points(amount:int) -> void:
	if Refs.main :
		if Refs.main.presentation_tab.visible :
			amount = Refs.main.presentation_tab.current_question.worth * sign(amount)
	set_points(points + amount)

func remove_points(amount:int) -> void:
	add_points(-amount)
