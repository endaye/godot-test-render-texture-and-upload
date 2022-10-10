extends Node2D

onready var captured = $captured
onready var https: HTTPRequest = $HTTPRequest

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
	print("pressed")


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

	print("released")

	send_https()


func send_https():
	print("send_https")
	# var file = File.new()
	# file.open('res://icon.png', File.READ)
	# var file_content = file.get_buffer(file.get_len())

	# var body = PoolByteArray()
	# body.append_array("\r\n--WebKitFormBoundaryePkpFF7tjBAqx29L\r\n".to_utf8())
	# body.append_array("Content-Disposition: form-data; name=\"image\"; filename=\"icon.png\"\r\n".to_utf8())
	# body.append_array("Content-Type: image/png\r\n\r\n".to_utf8())
	# body.append_array(file_content)
	# body.append_array("\r\n--WebKitFormBoundaryePkpFF7tjBAqx29L--\r\n".to_utf8())

	# var headers = [
	# 	"Content-Type: multipart/form-data;boundary=\"WebKitFormBoundaryePkpFF7tjBAqx29L\""
	# ]
	# var http = HTTPClient.new()
	# http.connect_to_host("https://api.imgur.com")

	# while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
	# 	http.poll()
	# 	OS.delay_msec(500)

	# assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Could not connect

	# var err = http.request_raw(HTTPClient.METHOD_POST, "/images" , headers, body)
	# print(err)
	# assert(err == OK) # Make sure all is OK.

	# while http.get_status() == HTTPClient.STATUS_REQUESTING:
	# 	# Keep polling for as long as the request is being processed.
	# 	http.poll()
	# 	if not OS.has_feature("web"):
	# 		OS.delay_msec(500)
	# 	else:
	# 		yield(Engine.get_main_loop(), "idle_frame")
	# var url = "https://api.imgur.com/3/upload"
	var file = File.new()
	file.open(img_path, File.READ)
	var file_content = file.get_buffer(file.get_len())

	var use_ssl = true
	#https.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	var imgbb_api = "https://api.imgbb.com/1/upload"
	var api_key = "a22e48fe6712236f0b2f963518910f8b"
	var img_name = "test"
	var params = [
		"key=%s" % api_key,
		"name=%s" % img_name,
	]
	# var body := to_json({"image": "https://i.ibb.co/D1yNsNg/test.jpg"})

	var body = PoolByteArray()
	body.append_array("\r\n--WebKitFormBoundary7MA4YWxk".to_utf8())
	body.append_array('\r\nContent-Disposition: form-data; name="image"\r\n'.to_utf8())
	body.append_array("\r\n".to_utf8())
	body.append_array("https://pbs.twimg.com/media/FetQkhqakAE7u_s?format=jpg".to_utf8())
	body.append_array("\r\n".to_utf8())
	body.append_array("--WebKitFormBoundary7MA4YWxk--".to_utf8())
	body.append_array("\r\n".to_utf8())

	print(body.size())
	var headers = [
		# "Host: api.imgbb.com",
		"Content-Type: multipart/form-data; charset=utf-8; boundary=WebKitFormBoundary7MA4YWxk",
		"Content-Length: " + str(body.size()),
		# "Cache-Control: no-cache"
	]

	print(body.get_string_from_utf8())

	# var headers = [
	# 	"Content-Type: multipart/form-data",
	# 	"Content-Length: %s" % 189,
	# 	"Host: api.imgbb.com",
	# ]

	# var http = HTTPClient.new()

	var url = imgbb_api + "?" + PoolStringArray(params).join("&")
	var error = https.request_raw(url, headers, use_ssl, HTTPClient.METHOD_POST, body)
	if error != OK:
		print(error)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("hahah")
	print(result)
	print(response_code)
	print(headers)
	#print(body)
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
