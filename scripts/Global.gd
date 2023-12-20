# Global.gd
extends Node

var active_player = "Barbarian"

func switch_player():
	active_player = "Mage" if active_player == "Barbarian" else "Barbarian"
