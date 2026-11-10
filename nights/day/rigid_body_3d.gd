extends StaticBody3D

func interact(_player: DayPlayer) -> void:
	if not is_visible_in_tree():
		return
	Dialogue.show("the green", "It's you.")
