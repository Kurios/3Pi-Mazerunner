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
final char ESCAPE = '\\';
final char PATHCHECK = 'C';
final char PANIC = '!';
final char MOVEFORWARD = 'M';

int current = 0; // current position in path
RobotDFS botAI = new RobotDFS();
boolean changing = false;
char nextMove = '0';
boolean[] directions = {false,false,false};
boolean turnCompleted =true;
char lastMove = '0';


//================================================================================================
// Check for triggers that change state, no motor commands here
//================================================================================================
void checkTriggers(int elapsed) {
  //if( keyPressed )
  //  {
  //while(key != 'a' )
  //{
  //}
  int sensors[] = readSensors();
  switch(state_) {

  case START:  
    // get out of start circle
    print(switched_);
    if ( sensors[4] < 200 && sensors[0] < 200 ) switchToState(FOLLOW);
    //println(" "+sensors[0]+" "+sensors[1]+" "+sensors[2]+" "+sensors[3]+" "+sensors[4]); 
    setSpeeds(10, 10);
    break;

  case FOLLOW:
    // allow some time to get back on the line
    /*if  ( changing )
    {
    	if ( elapsed > 100 )
    	{
    	  if ((lineType()==INTERSECTION) || lineType()==DEAD_END) switchToState(ENTER);
    	  changing = false;
    	 }
    }*/
    if (elapsed > 20) {    
      if ((lineType()==INTERSECTION) || lineType()==DEAD_END) switchToState(ENTER);
      

     //println(" "+sensors[0]+" "+sensors[1]+" "+sensors[2]+" "+sensors[3]+""+sensors[4]); 
    }
    
    
    break;

  case ENTER:
    
    // Drive straight a bit.
    // after we're GOAL, decide which way to turn
    //print(nextMove);
    if (elapsed > 10 && nextMove == '0') {
      directions = getTurns();
      print(nextMove);
      print(":"+elapsed + " , ");
      switchToState(MOVEFORWARD);
    }
    break;
    
    case MOVEFORWARD:
     if( elapsed > 20 && (! isIntersection() ))
     {

      switchToState(PATHCHECK);
     }
     if( elapsed > 500 ) switchToState(GOAL);
     break;
       
    case PATHCHECK:
    //print(" " + elapsed);
    setSpeeds(30,30);
    if( elapsed > 85 )
     { 
      if(lastMove != 'U')
         botAI.addNodes(directions[0],lineType()!=DEAD_END,directions[2]);
      nextMove = botAI.getNextMove(); 
      print("Robot AI going to " + nextMove + " , path home is:" + botAI.getShortestPath() + " Sensors Reported: " +directions[0] +", " +(lineType()!=DEAD_END)+", "+directions[2]+", state switched to: ");
      switch(nextMove) {
      case 'L':
        changing = true; 
        switchToState(TURN_LEFT);
        break;
      case 'F':
      	changing = true; 
        switchToState(FOLLOW); 
        break;
      case 'R':
      	changing = true; 
        switchToState(TURN_RIGHT); 
        
        break;
      case 'U':
      	changing = true;
        switchToState(TURN_AROUND);
        break;
      case 'G': 
        switchToState(GOAL); 
        break;
      case '!':
        switchToState(PANIC);
        break;
      }
      lastMove = nextMove; 
      nextMove = '0';

      
     }
    break;

  case TURN_LEFT:  
    if (elapsed> 10 && isOnLine() ) switchToState(FOLLOW);
    break;

  case TURN_RIGHT:  
    if (elapsed> 10 && isOnLine() ) switchToState(FOLLOW);
    break;
    
  case TURN_AROUND:
  	if (elapsed>10 && isOnLine() ) switchToState(FOLLOW);
	break;
	
  case GOAL:  
    // Wait for button-press, then restart everything
    waitForButtonPress();
    current=0;
    switchToState(START);
    break;
  } // switch
   /// }
 //   else{
 //     setSpeeds(0,0);
 //  }
}

//================================================================================================
// now execute current behavior
//================================================================================================
void executeBehavior(int elapsed) {
  switch(state_) {

  case START:  
    if (switched_==1) setSpeeds(20, 20);
    break;

  case FOLLOW:  
    followPID(switched_);
    break;
  
  case PATHCHECK:
     if (switched_==1) setSpeeds(30,30);
    break;
  case ENTER:  
    // Note that we are slowing down - this prevents the robot
    // from tipping forward too much.
    if (switched_==1) setSpeeds(20,20);
    break;

  case TURN_LEFT:  
    if (switched_==1) setSpeeds(-110, 110);
    break;

  case TURN_RIGHT:  
    if (switched_==1) setSpeeds(110, -110);
    break;

  case TURN_AROUND:
    if  (switched_==1 ) setSpeeds(110, -110);
    break;
    
  case GOAL:  
    if (switched_==1) setSpeeds(0, 0);
   
   case PANIC:
     if (switched_==1) setSpeeds(255,255);
     break;
   

  } // switch
}

//================================================================================================



