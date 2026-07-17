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

static func swap_elements(array: Array, a:Variant, b:Variant) -> Error:
	if a in array and b in array :
		var id_a := array.find(a)
		var id_b := array.find(b)
		array.erase(a)
		var err_a := array.insert(id_b, a) as Error
		if err_a != OK : return err_a
		array.erase(b)
		var err_b := array.insert(id_a, b) as Error
		if err_b != OK : return err_b
	return OK

static func disconnect_signal(s:Signal) -> void:
	for connection:Dictionary in s.get_connections():
		s.disconnect(connection["callable"])
