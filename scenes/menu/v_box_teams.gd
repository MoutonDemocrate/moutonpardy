extends VBoxContainer
class_name VBoxTeamsSetup

@export var new_team_button: Button
@export var teams_container: VBoxContainer

func _ready() -> void:
	new_team_button.pressed.connect(
		func () -> void:
			var team_panel := TeamSetupControl.create()
			teams_container.add_child(team_panel)
	)

func get_teams() -> Dictionary[String, Color] :
	var teams: Dictionary[String, Color] = {}
	for child:Control in teams_container.get_children():
		if child is TeamSetupControl :
			teams[child.team_name_edit.text] = child.color_button.color
	return teams
