public class RobotDFS {

	DFSNode current;
	
	public RobotDFS(){
		current = new DFSNode(null);
		current.straight = new DFSNode(current);
	}
	
	public void addNodes(boolean left, boolean straight, boolean right){
		if(left)	current.left = new DFSNode(current);
		if(right) 	current.right = new DFSNode(current);
		if(straight)current.straight = new DFSNode(current);
	}
	
	public char getNextMove()
	{
		if(current.left != null && ((current.visited & DFSNode.VISTED_LEFT) == 0 )) 
		{
			current.visited = (byte) (current.visited | DFSNode.VISTED_LEFT) ;
			current = current.left;
			return 'L';
		}else if(current.right != null && ((current.visited & DFSNode.VISTED_RIGHT) == 0 )) 
		{
			current.visited = (byte) (current.visited | DFSNode.VISTED_RIGHT) ;
			current = current.right;
			return 'R';
		}else if(current.straight != null && ((current.visited & DFSNode.VISTED_STRAIGHT) == 0 )) 
		{
			current.visited = (byte) (current.visited | DFSNode.VISTED_STRAIGHT) ;
			current = current.straight;
			return 'F';
		}else {
			if( current.parent != null )
			{
				current = current.parent;
				return 'U';
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
			if (trace == trace.parent.left ) ret = ret  + " L";
			else if (trace == trace.parent.right ) ret = ret + " R";
			else if (trace == trace.parent.straight ) ret = ret + " F";
			else ret =  ret + " OMG FAIL! ";
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


