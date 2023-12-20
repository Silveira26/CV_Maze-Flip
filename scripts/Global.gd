# Global.gd
extends Node

var active_player = "Mage"

func switch_player():
	active_player = "Barbarian" if active_player == "Mage" else "Mage"
