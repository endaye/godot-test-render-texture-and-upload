extends Node2D

const PORT := 3000
const BINDING := "127.0.0.1"
const client_id := "57589beb9315dd1"
const client_secret := "841f2ecf8639310d9de2675a18fa7644332877b6"
const auth_server := "https://api.imgur.com/oauth2/authorize"
const token_req := ""

var redirect_server := TCP_Server.new()
var redirect_url := "http://%s:%s" % [BINDING, PORT]

var token
var refresh_token


func _ready():
	set_process(false)
	get_auth_code()


func _process(_dt):
	if redirect_server.is_connection_available():
		# var connection
		pass


func get_auth_code():
	set_process(true)

	var redir_err = redirect_server.listen(PORT, BINDING)
	var body_parts = [
		"client_id=%s" % client_id,
		"response_type=token",
	]

	var url = auth_server + "?" + PoolStringArray(body_parts).join("&")

	var err = OS.shell_open(url)
	if err != OK:
		print(err)
