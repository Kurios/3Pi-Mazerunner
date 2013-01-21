//================================================================================================
// define states here, do not repeat characters 
//================================================================================================
final char START = 'S'; // always needs to be defined !
final char FOLLOW = 'F';
final char ENTER = 'E';
final char TURN_LEFT = 'L';
final char TURN_RIGHT = 'R';
final char GOAL = 'G';
final char TURN_AROUND = 'U';

int current = 0; // current position in path
RobotDFS botAI = new RobotDFS();
//================================================================================================
// Check for triggers that change state, no motor commands here
//================================================================================================
void checkTriggers(int elapsed) {

  switch(state_) {

  case START:  
    // get out of start circle
    if (elapsed>170) switchToState(FOLLOW);
    break;

  case FOLLOW:
    // allow some time to get back on the line
    if (elapsed > 30) {    
      if ((lineType()==INTERSECTION) || lineType()==DEAD_END) switchToState(ENTER);
    }
    break;

  case ENTER:  
    // Drive straight a bit.
    // after we're GOAL, decide which way to turn
    
    if (elapsed>10) {
      boolean[] directions = getTurns();
      botAI.addNodes(directions[0],directions[1],directions[2]);
      char direction = botAI.getNextMove();
      print(direction);
      print(directions[0] + " ");
      print(directions[1] + " ");
      print(directions[2]);
      switch(direction) {
      case 'L': 
        switchToState(TURN_LEFT); 
        break;
      case 'F': 
        switchToState(FOLLOW); 
        break;
      case 'R': 
        switchToState(TURN_RIGHT); 
        break;
      case 'U':
        switchToState(TURN_AROUND);
        break;
      case 'G': 
        switchToState(GOAL); 
        break;
      }
    }
    break;

  case TURN_LEFT:  
    if (elapsed>180) switchToState(FOLLOW);
    break;

  case TURN_RIGHT:  
    if (elapsed>180) switchToState(FOLLOW);
    break;
    
  case TURN_AROUND:
  	if (elapsed>360) switchToState(FOLLOW);
	break;
	
  case GOAL:  
    // Wait for button-press, then restart everything
    waitForButtonPress();
    current=0;
    switchToState(START);
    break;
  } // switch
}

//================================================================================================
// now execute current behavior
//================================================================================================
void executeBehavior(int elapsed) {
  switch(state_) {

  case START:  
    if (switched_==1) setSpeeds(60, 60);
    break;

  case FOLLOW:  
    followPID(switched_);
    break;

  case ENTER:  
    // Note that we are slowing down - this prevents the robot
    // from tipping forward too much.
    if (switched_==1) setSpeeds(200, 200);
    break;

  case TURN_LEFT:  
    if (switched_==1) setSpeeds(-80, 80);
    break;

  case TURN_RIGHT:  
    if (switched_==1) setSpeeds(80, -80);
    break;

  case TURN_AROUND:
    if  (switched_==1 ) setSpeeds(80, -80);
    break;
    
  case GOAL:  
    if (switched_==1) setSpeeds(0, 0);
   

  } // switch
}

//================================================================================================



