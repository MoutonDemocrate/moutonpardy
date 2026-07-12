extends PanelContainer
class_name MainClass

@export var board_tab: BoardTab
@export var presentation_tab: PresentationTab
@export var new_board_tab: NewBoardTab
@export var victory_tab: VictoryTab
@export var teams_container: TeamPanelsContainer

var boards: Array[Board] = []
var current_board_id: int = 0

signal game_ended

const SCENE := preload("res://scenes/game/main.tscn")

func question_time(question:Question, in_column:Column) -> void:
	print("Called Question : ", in_column.title," for ", question.worth, " points.")
	await presentation_tab.question_time(question, in_column)
	if board_tab.is_over() :
		print("Board is over, next board...")
		next_board()
	else:
		board_tab.show()

func _ready() -> void:
	Refs.main = self

func start_game(with_boards:Array[Board], with_teams:Dictionary[String, Color]) -> void:
	boards = with_boards
	teams_container.initialise(with_teams)
	current_board_id = -1
	self.show()
	next_board()

func next_board() -> void:
	current_board_id += 1
	if current_board_id == len(boards):
		print("End of game !")
		end_of_game()
		return
	await new_board_tab.present_board(boards[current_board_id])
	board_tab.load_board(boards[current_board_id])
	board_tab.show()

func end_of_game() -> void:
	var leading_team := teams_container.get_leading_team_panel()
	await victory_tab.victory_screen(leading_team)
	print("Back to main menu...")
	game_ended.emit()
