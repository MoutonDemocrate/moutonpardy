extends Object
class_name Utils

static func free_children(node:Node) -> void:
	for child:Node in node.get_children():
		child.free()

static func delete_duplicates(array:Array) -> Array:
	var new_array: Array = []
	for element in array:
		if not element in new_array:
			new_array.append(element)
	return new_array

static func disconnect_signal(s:Signal) -> void:
	for connection:Dictionary in s.get_connections():
		s.disconnect(connection["callable"])
