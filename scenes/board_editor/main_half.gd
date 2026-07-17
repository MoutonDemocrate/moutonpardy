extends VBoxContainer
class_name EditorMainHalf

@export var editor: BoardEditor

@export var board_name_edit: LineEdit

@export var column_container: HBoxContainer
@export var add_column_button: Button

func _ready() -> void:
	board_name_edit.mouse_exited.connect(
		func () -> void:
			if board_name_edit.text != editor.current_board.board_name :
				print("Board name changed : ",editor.current_board," -> ", board_name_edit.text)
				editor.current_board.board_name = board_name_edit.text
				editor.save_board()
	)
	for child:Node in column_container.get_children() :
		if child != add_column_button :
			child.free()
	add_column_button.pressed.connect(
		func () -> void:
			var new_column := Column.new()
			var new_title := "Category " + str(column_container.get_child_count())
			new_column.title = new_title
			editor.current_board.columns.append(new_column)
			var control := add_column(new_column)
			control.category_text_edit.text = new_title
	)

func start_editing(new_board:Board) -> void:
	board_name_edit.text = new_board.board_name
	clear_all_columns_but_keep_data()
	for column:Column in new_board.columns:
		add_column(column)

func add_column(column:Column) -> VBoxColumnEditor:
	var new_category := VBoxColumnEditor.from_column(column, editor)
	new_category.column_title_changed.connect(
		func (nt:String) -> void:
			print("Column name changed : ",new_category.associated_column.title," -> ", nt)
			editor.save_board()
	)
	new_category.delete_button_pressed.connect(
		func () -> void:
			remove_column(new_category)
			editor.save_board()
	)
	column_container.add_child(new_category)
	column_container.move_child(new_category, new_category.get_index() - 1)
	editor.save_board()
	return new_category

func remove_column(vbox_column:VBoxColumnEditor) -> void:
	print("Removing editor column associated with column : ", vbox_column.associated_column)
	if vbox_column.associated_column in editor.current_board.columns:
		editor.current_board.columns.erase(vbox_column.associated_column)
	for question_button:EditorQuestionButton in vbox_column.get_question_buttons():
		vbox_column.remove_question(question_button)
	vbox_column.queue_free()

func get_vbox_columns() -> Array[VBoxColumnEditor]:
	var cols: Array[VBoxColumnEditor] = []
	for child:Node in self.column_container.get_children() :
		if child is VBoxColumnEditor :
			cols.append(child)
	return cols

func clear_all_columns() -> void:
	for vbox_column:VBoxColumnEditor in self.get_vbox_columns() :
		remove_column(vbox_column)


func clear_all_columns_but_keep_data() -> void:
	for vbox_column:VBoxColumnEditor in self.get_vbox_columns() :
		vbox_column.queue_free()
