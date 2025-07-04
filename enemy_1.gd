extends StaticBody3D

var display_name = "Holy Diver"

func on_hover():
	scale = Vector3(1.2, 1.2, 1.2)
	
func on_unhover():
	scale = Vector3(1, 1, 1)
