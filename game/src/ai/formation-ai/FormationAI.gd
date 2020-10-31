extends Node

# TODO check if final state machine would make more sense for this AIS

# makes the formation for the team to playe the next match
# might be only used for teams that play against you
# others just use best fisic players or so and get random stats anyway
func make_formation(team):
	pass


# checks during match if changes should be made
# according to lines tactics and stamina
# can be used also for your formation in 
# automated change mode
func check_changes(players):
	pass



# to replace a single player in case of injury or manual
# changes, or red card and so tactitc changes etc.
func replace_player(player,players):
	pass
