extends SubViewportContainer

# 1. Get a reference to the SubViewport
@onready var sub_viewport: SubViewport = $SubViewport

func _ready():
	# Wait two frames for the SubViewport to render its contents
	await get_tree().process_frame
	await get_tree().process_frame
	save_viewport_as_png(sub_viewport, "user://my_node_export.png")

# This function takes a viewport and a path and saves it as a PNG
func save_viewport_as_png(viewport: Viewport, path: String) -> void:
	
	# 2. Get the texture from the viewport
	var texture: ViewportTexture = viewport.get_texture()
	
	# 3. Get the image data from the texture
	var image: Image = texture.get_image()
	
	# 4. Save the image to the specified path as a PNG
	var error = image.save_png(path)
	
	if error == OK:
		print("Successfully saved PNG to: ", path)
	else:
		print("Failed to save PNG. Error code: ", error)
