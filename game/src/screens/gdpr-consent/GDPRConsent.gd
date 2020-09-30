extends Control


func _on_Consent_pressed():
	DataSaver.gdpr_consent = DataSaver.GDPR_CONSENTS.ACCEPT
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Decline_pressed():
	DataSaver.gdpr_consent = DataSaver.GDPR_CONSENTS.ACCEPT
	GameAnalytics.GDPR_disable_events()
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")
