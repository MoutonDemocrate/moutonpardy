extends VBoxContainer
class_name EditorMainHalf

@export var editor: BoardEditor

@export var board_name_edit: LineEdit

@export var column_container: HBoxContainer
@export var add_column_button: Button

func _ready() -> void:
	board_name_edit.text_changed.connect(
		func (nbn:String) -> void:
			print("Board name changed : ",editor.current_board," -> ", nbn)
			editor.current_board.board_name = nbn
			editor.save_board()
	)
	for child:Node in column_container.get_children() :
		if child != add_column_button :
			child.free()

func start_editing(new_board:Board) -> void:
	board_name_edit.text = new_board.board_name
	for column:Column in new_board.columns:
		add_column(column)

func add_column(column:Column) -> void:
	var new_category := VBoxColumnEditor.from_column(column, editor)
	new_category.column_title_changed.connect(
		func (nt:String) -> void:
			print("Column name changed : ",new_category.associated_column.title," -> ", nt)
			editor.save_board()
	)
	column_container.add_child(new_category)
	column_container.move_child(new_category, new_category.get_index() - 1)
