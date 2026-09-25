extends "../base_menu/base_menu.gd"

func on_accept():
	var option = options[selected_index]

	match option.option_id:
		"LEVEL_START":
			DebugMenu.toggle()
			SceneManager.goto(SceneManager.SceneID.LEVEL_0_START)

		"LEVEL_1", "LEVEL_2", "LEVEL_3","LEVEL_4","LEVEL_5":
			var marker_name = option.option_id.replace("LEVEL_", "Level")

			DebugMenu.toggle()
			SceneManager.goto(
				SceneManager.SceneID.LEVEL_COMPLETE,
				marker_name
			)
	
