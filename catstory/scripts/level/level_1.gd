extends Node2D


func _on_audio_stream_player_1_finished() -> void:
	$Node2D/AudioStreamPlayer2.play()


func _on_audio_stream_player_2_finished() -> void:
	$Node2D/AudioStreamPlayer1
