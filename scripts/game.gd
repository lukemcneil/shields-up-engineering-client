extends Control

@onready var my_systems: Systems = %MySystems as Systems
@onready var opponent_systems: Systems = %OpponentSystems as Systems
@onready var hand: Hand = %Hand as Hand

# The URL we will connect to.
#@export var websocket_url = "ws://127.0.0.1:8000/game"
@export var websocket_url = "wss://shields-up-engineering-server.onrender.com/game"
var players_turn : String
var selected_card_index: int = -1
var selected_system: System.SystemName

# Our WebSocketClient instance.
var socket := WebSocketPeer.new()

func _ready():
	# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		print("Connected to server")

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer and state updates
	# will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	# WebSocketPeer.STATE_OPEN means the socket is connected and ready
	# to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var text := socket.get_packet().get_string_from_utf8();
			var json = JSON.new()
			var error = json.parse(text)
			if error == OK:
				var data_received = json.data
				_update_state(data_received)
			else:
				print("JSON Parse Error: ", json.get_error_message(), " in ", text, " at line ", json.get_error_line())

	# WebSocketPeer.STATE_CLOSING means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.

func _update_state(state: Dictionary):
	if state.has("player1"):
		var player1_state: Dictionary = state.player1
		var player2_state: Dictionary = state.player2
		$PlayerInfo/CardsInHand.text = "Cards In Hand: " + str(len(player1_state.hand))
		$PlayerInfo/PlayersTurn.text = "Players Turn: " + state.players_turn
		players_turn = state.players_turn
		$PlayerInfo/ActionsLeft.text = "Actions Left: " + str(state.actions_left)
		$PlayerInfo/TurnState.text = "Turn State: " + str(state.turn_state)
		
		my_systems.update_system_state(player1_state)
		opponent_systems.update_system_state(player2_state)
		hand.update_hand(player1_state.hand)
		_on_hand_selected_card_changed(-1)
		_on_my_systems_system_selected(System.SystemName.FUSION_REACTOR)
	else:
		$ActionResult.text = "Action Result: " + str(state)

#func _on_send_action_button_pressed() -> void:
	#socket.send_text('{"player":"' + players_turn + '","user_action":{"ChooseAction":{"action":{"HotWireCard":{"card_index":0, "system": "LifeSupport", "indices_to_discard": []}}}}}')
#
#
#func _on_stop_resolving_button_pressed() -> void:
	#socket.send_text('{"player":"' + players_turn + '","user_action":"StopResolvingEffects"}')
#
#
#func _on_pass_button_pressed() -> void:
	#socket.send_text('{"player":"' + players_turn + '","user_action":{"Pass": {"card_indices_to_discard": []}}}')

func _on_hand_selected_card_changed(i: int) -> void:
	selected_card_index = i
	$PlayerInfo/SelectedCard.text = "Selected Card: " + str(selected_card_index)

func _on_my_systems_system_selected(system_name: System.SystemName) -> void:
	selected_system = system_name
	$PlayerInfo/SelectedSystem.text = "Selected System: " + str(System.SystemName.find_key(selected_system))

func _on_play_instant_pressed() -> void:
	if selected_card_index != -1:
		socket.send_text('{"player":"' + players_turn + '","user_action":{"ChooseAction":{"action":{"PlayInstantCard":{"card_index":' + str(selected_card_index) + '}}}}}')
