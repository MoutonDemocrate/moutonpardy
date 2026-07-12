extends CenterContainer
class_name NewGameTab

@export var start_game_button: Button
@export var error_label: Label

@export var teams_setup: VBoxTeamsSetup
@export var boards_setup: VBoxBoardsSetup

@export var main_menu: MainMenuClass

func _ready() -> void:
	error_label.text = ""
	start_game_button.pressed.connect(start_game)

func start_game() -> void:
	error_label.text = ""

	var teams := teams_setup.get_teams()
	if not teams:
		error_label.text += "\n" if error_label.text else ""
		error_label.text += "You don't have any teams set up!"
	elif "" in teams.keys():
		error_label.text += "\n" if error_label.text else ""
		error_label.text += "Team n°" + str(teams.keys().find("")) + " has no name !"

	var boards := boards_setup.get_boards()
	if not boards:
		error_label.text += "\n" if error_label.text else ""
		error_label.text += "You don't have any boards set up!"

	if error_label.text != "" :
		return

	main_menu.start_game(boards, teams)
