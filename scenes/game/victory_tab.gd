extends CenterContainer
class_name VictoryTab

@export var team_name_label: Label
@export var points_label: Label
@export var return_button: Button

func victory_screen(leading_team_panel:TeamPanel) -> void:
	if leading_team_panel:
		team_name_label.text = "\"" + leading_team_panel.team_name + "\""
		points_label.text = "with " + str(leading_team_panel.points) + " points"
	else:
		team_name_label.text = "NO ONE"
		points_label.text = "You somehow all suck!"

	self.show()

	await return_button.pressed
