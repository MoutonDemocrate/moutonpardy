extends HBoxContainer
class_name TexturePicker

@export var texture_rect: TextureRect
@export var select_button: Button
@export var clear_button: Button
@export var file_dialog: FileDialog

signal texture_changed(texture:Texture2D)

func _ready() -> void:
	clear_button.pressed.connect(
		func () -> void:
			load_texture(null)
	)
	select_button.pressed.connect(file_dialog.show)
	file_dialog.file_selected.connect(
		func (path:String) -> void:
			var image := Image.new()
			image.load(path)
			if is_instance_valid(image):
				var image_texture := ImageTexture.create_from_image(image)
				load_texture(image_texture)
	)

func load_texture(texture:Texture2D) -> void:
	load_texture_no_signal(texture)
	texture_changed.emit(texture)

func load_texture_no_signal(texture:Texture2D) -> void:
	texture_rect.texture = texture
	if texture:	clear_button.show()
	else:		clear_button.hide()

func has_texture_selected() -> bool:
	if texture_rect:
		if texture_rect.texture:
			return true
	return false

func get_texture() -> Texture2D :
	if has_texture_selected():	return texture_rect.texture
	else:						return null
