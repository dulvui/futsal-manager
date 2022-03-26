extends Node

enum states {GO_HOME,RECEIVE_BALL}

var state

var position
var velocity
var heading

func update():
	pass
#	//run the logic for the current state
#  m_pStateMachine->Update();
#
#  //calculate the combined force from each steering behavior 
#  Vector2D SteeringForce = m_pSteering->Calculate();
#
#
#
#  //Acceleration = Force/Mass
#  Vector2D Acceleration = SteeringForce / m_dMass;
#
#  //update velocity
#  m_vVelocity += Acceleration;
#
#  //make sure player does not exceed maximum velocity
#  m_vVelocity.Truncate(m_dMaxSpeed);
#
#  //update the position
#  m_vPosition += m_vVelocity;
#
#
#  //enforce a non-penetration constraint if desired
#  if(Prm.bNonPenetrationConstraint)
#  {
#    EnforceNonPenetrationContraint(this, AutoList<PlayerBase>::GetAllMembers());
#  }
#
#  //update the heading if the player has a non zero velocity
#  if ( !m_vVelocity.isZero())
#  {    
#    m_vHeading = Vec2DNormalize(m_vVelocity);
#
#    m_vSide = m_vHeading.Perp();
#  }
#
#  //look-at vector always points toward the ball
#  if (!Pitch()->GoalKeeperHasBall())
#  {
#   m_vLookAt = Vec2DNormalize(Ball()->Pos() - Pos());
#  }


#bool GoalKeeper::BallWithinRangeForIntercept()const
#{
#  return (Vec2DDistanceSq(Team()->HomeGoal()->Center(), Ball()->Pos()) <=
#          Prm.GoalKeeperInterceptRangeSq);
#}
#
#bool GoalKeeper::TooFarFromGoalMouth()const
#{
#  return (Vec2DDistanceSq(Pos(), GetRearInterposeTarget()) >
#          Prm.GoalKeeperInterceptRangeSq);
#}
#
#Vector2D GoalKeeper::GetRearInterposeTarget()const
#{
#  double xPosTarget = Team()->HomeGoal()->Center().x;
#
#  double yPosTarget = Pitch()->PlayingArea()->Center().y - 
#                     Prm.GoalWidth*0.5 + (Ball()->Pos().y*Prm.GoalWidth) /
#                     Pitch()->PlayingArea()->Height();
#
#  return Vector2D(xPosTarget, yPosTarget); 
#}
