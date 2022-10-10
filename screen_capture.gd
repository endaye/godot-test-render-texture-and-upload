extends Node2D

onready var captured = $captured

var image = Image.new()

var img

var img_exists = File.new()

var img_path = "user://img.png"

var tex = ImageTexture.new()

func _ready():
	# Load image
	if img_exists.file_exists(img_path):
		image.load(img_path)
		tex.create_from_image(image)
		captured.set_texture(tex)

func _on_button_pressed():
	# Delete texture
	captured.texture = null
	print('pressed')

func _on_button_button_up():
	# Get screenshot from screen
	img = get_viewport().get_texture().get_data()
	img.flip_y()
	
	# Save screenshot as png
	img.save_png(img_path)
	
	# Create texture for it
	tex.create_from_image(img)
	
	# Set it to be captured
	captured.set_texture(tex)
	
	print('released')
	
	


