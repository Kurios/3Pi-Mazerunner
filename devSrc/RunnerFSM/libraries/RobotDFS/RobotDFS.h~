#ifndef Morse_h
#define Morse_h

#include "Arduino.h"

class DFSNode {
	public: 
		byte visited;
		DFSNode * straight;
		DFSNode * right;
		DFSNode * left;
		DFSNode * parent;
		DFSNode(DFSNode*);
	};

class RobotDFS {
	public:
		DFSNode * current;
		boolean backtracking;
        	int directionality;
		RobotDFS();
		char getNextMove();
		void addNodes(boolean left, boolean straight, boolean right);
		char * getShortestPath();
        private:
		 char setMove(int facing, int move);
};

#endif


