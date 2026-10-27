extends Node2D

@onready var tetris_tile_map: TileMapLayer = $TetrisTileMap

func pause() -> void:
	tetris_tile_map._pause()
