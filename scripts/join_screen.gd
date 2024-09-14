class_name JoinScreen
extends Control

@onready var game_room: LineEdit = %GameRoom
@onready var join: Button = %Join
@onready var player: OptionButton = %Player

var game_scene := preload("res://scenes/game.tscn")

func _on_join_pressed() -> void:
	var game: Game = game_scene.instantiate()
	game.game_room = game_room.text
	if game.game_room.is_empty():
		game.game_room = "test"
	game.player = player.selected as Game.Player
	get_tree().root.add_child(game)
	get_tree().root.remove_child(self)
