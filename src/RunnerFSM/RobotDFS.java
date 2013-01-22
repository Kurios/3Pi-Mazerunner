public class RobotDFS {

	DFSNode current;
	boolean backtracking = false;
        int directionality = 0;

	public RobotDFS(){
		current = new DFSNode(null);
		current.straight = new DFSNode(current);
	}
	
	public void addNodes(boolean left, boolean straight, boolean right){
		if(left)	current.left = new DFSNode(current);
		if(right) 	current.right = new DFSNode(current);
		if(straight)current.straight = new DFSNode(current);
	}
	
        private char setMove(int facing, int move)
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

	public char getNextMove()
	{
                int directionality = this.directionality; 
                
		if(current.left != null && ((current.visited & DFSNode.VISTED_LEFT) == 0 )) 
		{
			current.visited = (byte) (current.visited | DFSNode.VISTED_LEFT) ;
			current = current.left;
                        this.directionality = 0;
			return setMove(directionality,1);
		}else if(current.right != null && ((current.visited & DFSNode.VISTED_RIGHT) == 0 )) 
		{
			current.visited = (byte) (current.visited | DFSNode.VISTED_RIGHT) ;
			current = current.right;
                        this.directionality = 0;
			return setMove(directionality,3);
		}else if(current.straight != null && ((current.visited & DFSNode.VISTED_STRAIGHT) == 0 )) 
		{
			current.visited = (byte) (current.visited | DFSNode.VISTED_STRAIGHT) ;
			current = current.straight;
                        this.directionality = 0;
			return setMove(directionality,0);
		}else {
			if( current.parent != null )
			{
				current = current.parent;
                                backtracking = true;
                                if (current == current.parent.left ) this.directionality = 1;
                                else if (current == current.parent.right ) this.directionality = 3;
                                else if (current == current.parent.straight ) this.directionality = 2;
				return setMove(directionality,2);
			}
			return '!';
		}
	}
	
	public String getShortestPath()
	{
		String ret = "";
		DFSNode trace = current;
		while(trace.parent != null)
		{
			if (trace == trace.parent.left ) ret = " L" + ret;
			else if (trace == trace.parent.right ) ret = " R" + ret;
			else if (trace == trace.parent.straight ) ret = " F" + ret;
			else ret =  " FAIL" + ret;
			trace = trace.parent;
		}
		return ret;
	}
	
	private class DFSNode {
		final static byte VISTED_LEFT = 0x1;
		final static byte VISTED_RIGHT = 0x2;
		final static byte VISTED_STRAIGHT = 0x4;
		byte visited = 0;
		DFSNode straight = null;
		DFSNode right = null;
		DFSNode left = null;
		DFSNode parent = null;
		
		public DFSNode(DFSNode parent)
		{
			this.parent = parent;
		}
	}
}


