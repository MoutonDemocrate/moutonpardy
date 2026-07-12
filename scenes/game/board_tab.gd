extends HBoxContainer
class_name BoardTab

var active_board: Board

@export var column_container: HBoxContainer

func load_board(new_board:Board) -> void:
	active_board = new_board
	Utils.free_children(column_container)
	for column:Column in new_board.columns :
		var question_column := QuestionColumn.from_column(column)
		column_container.add_child(question_column)

## Returns [code]true[/code] if all questions have been done
func is_over() -> bool:
	print("Checking if ", active_board, " is over...")
	for child:Control in column_container.get_children():
		if child is QuestionColumn:
			if not child.is_done():
				print(child.column.title, " is not over ❌")
				return false
			print(child.column.title, " is over ✅")
	return true
