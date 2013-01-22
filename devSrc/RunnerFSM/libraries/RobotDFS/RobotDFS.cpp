#include "RobotDFS.h"
#include <string.h>

byte VISTED_LEFT = 0x1;
byte VISTED_RIGHT = 0x2;
byte VISTED_STRAIGHT = 0x4;

int _directionality = 0;

RobotDFS::RobotDFS() {
	RobotDFS::current = new DFSNode(NULL);
	RobotDFS::current->straight = new DFSNode(RobotDFS::current);
	RobotDFS::backtracking = false;
	RobotDFS::directionality = false;
}

void RobotDFS::addNodes(boolean left, boolean straight, boolean right){
	if(left) current->left = new DFSNode(current);
	if(right) current->right = new DFSNode(current);
	if(straight) current->straight = new DFSNode(current);
}

char RobotDFS::setMove(int facing, int move)
{
	//       1L  
        //   2  B<->F  0F
        //       3R
        int direction = ( facing + move )%4;
        switch(direction)
        {
          case 0: return 'F';
          case 1: return 'L';
          case 2: return 'U';
          case 3: return 'R';
        }
        return '!';
}

char RobotDFS::getNextMove()
	{
                int directionality = _directionality; 
                
		if(current->left != NULL && ((current->visited & VISTED_LEFT) == 0 )) 
		{
			current->visited = (byte) (current->visited | VISTED_LEFT) ;
			current = current->left;
                        _directionality = 0;
			return setMove(directionality,1);
		}else if(current->right != NULL && ((current->visited & VISTED_RIGHT) == 0 )) 
		{
			current->visited = (byte) (current->visited | VISTED_RIGHT) ;
			current = current->right;
                        _directionality = 0;
			return setMove(directionality,3);
		}else if(current->straight != NULL && ((current->visited & VISTED_STRAIGHT) == 0 )) 
		{
			current->visited = (byte) (current->visited | VISTED_STRAIGHT) ;
			current = current->straight;
                        _directionality = 0;
			return setMove(directionality,0);
		}else {
			if( current->parent != NULL )
			{
				current = current->parent;
                                backtracking = true;
                                if (current == current->parent->left ) _directionality = 1;
                                else if (current == current->parent->right ) _directionality = 3;
                                else if (current == current->parent->straight ) _directionality = 2;
				return setMove(directionality,2);
			}
			return '!';
		}
	}
	
char * RobotDFS::getShortestPath()
{
	String ret = "";
	DFSNode * trace = current;
	while(trace->parent != NULL)
	{
		if (trace == trace->parent->left ) ret = " L" + ret;
		else if (trace == trace->parent->right ) ret = " R" + ret;
		else if (trace == trace->parent->straight ) ret = " F" + ret;
		else ret =  " FAIL" + ret;
		trace = trace->parent;
	}

	return (char*)&(ret);
}

	

DFSNode::DFSNode(DFSNode * parentNode)
{
	parent = parentNode;
	visited = 0;
	straight = NULL;
	right = NULL;
	left = NULL;
	parent = NULL;	
}



