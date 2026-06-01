extends Node

signal wave_changed(text: String)
signal item_bought(item_data: ItemData)
signal victory
signal defeat
signal inventory_opened
signal stats_opened

var game_end: bool = false
