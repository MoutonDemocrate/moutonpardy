extends Resource
class_name Board

@export var board_name: String
@export var columns: Array[Column]

func _to_string() -> String:
	var stringed: String = self.board_name + " :"
	for column:Column in columns:
		stringed += "\n· "+ str(column) + " × " + str(column.get_question_points()).replace("[","(").replace("]",")")
	#stringed = stringed.substr(0, len(stringed)-2)
	return stringed

func apply_multiplier(multiplier:int) -> Board:
	for column:Column in columns :
		for question:Question in column.questions:
			question.worth *= multiplier
	return self

func get_points_array() -> PackedInt32Array :
	var points_array: PackedInt32Array = PackedInt32Array([])
	for column:Column in columns :
		points_array.append_array(column.get_question_points())
	points_array = Utils.delete_duplicates(points_array)
	points_array.sort()
	return points_array
