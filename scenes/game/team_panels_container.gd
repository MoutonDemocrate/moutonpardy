extends HBoxContainer
class_name TeamPanelsContainer

func _ready() -> void:
	self.show()
	Utils.free_children(self)

func initialise(teams:Dictionary[String, Color]) -> void:
	for team_name:String in teams.keys() :
		var team_panel := TeamPanel.from_team_name(team_name, teams[team_name])
		add_child(team_panel)
		team_panel.points_changed.connect(team_points_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("teams") :
		visible = not visible

func team_points_changed(_new_points:int) -> void:
	var leading_team := get_leading_team_panel()
	for team_panel:TeamPanel in self.get_children() :
		if team_panel == leading_team :
			team_panel.leading = true
		else :
			team_panel.leading = false

func get_leading_team_panel() -> TeamPanel:
	var max_points: int = -99999
	var max_team: TeamPanel = null
	for team_panel:TeamPanel in self.get_children() :
		if team_panel.points > max_points :
			max_points = team_panel.points
			max_team = team_panel
	if not max_team :
		return null
	else:
		return max_team
