extends Node

var GameAnalytics


func _ready():
	# ... other code from your project ...
	if(Engine.has_singleton("GameAnalytics")):
		print("GAMEANALYtICSSSSSSSSSSSSSSSSSSss")
		GameAnalytics = Engine.get_singleton("GameAnalytics")
		GameAnalytics.setEnabledInfoLog(true)
		GameAnalytics.setEnabledVerboseLog(true)

		GameAnalytics.configureAutoDetectAppVersion(true)

#		GameAnalytics.configureAvailableCustomDimensions01(["ninja", "samurai"])
#		GameAnalytics.configureAvailableCustomDimensions02(["whale", "dolphin"])
#		GameAnalytics.configureAvailableCustomDimensions03(["horde", "alliance"])
#		GameAnalytics.configureAvailableResourceCurrencies(["gold", "gems"])
#		GameAnalytics.configureAvailableResourceItemTypes(["boost", "lives"])

		GameAnalytics.init("cd0e542f8e7bc2d3c33689e1e3dc7601", "9de227b0dd5d0ed253305294f1de52e5987d3783")

func GDPR_disable_events():
	GameAnalytics.setEnabledEventSubmission(false);
	
func event(id):
	if GameAnalytics:
		GameAnalytics.addDesignEvent({
			"eventId": id
		})
