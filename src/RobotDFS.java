
public class RobotDFS {

	DFSNode current;
	
	public RobotDFS(){
		current = new DFSNode();
		current.straight = new DFSNode();
	}
	
	public void addNodes(boolean left, boolean straight, boolean right){
		if(left)	current.left = new DFSNode();
		if(right) 	current.right = new DFSNode();
		if(straight)current.straight = new DFSNode();
	}
	
	public char getNextMove()
	{
		if(current.left != null && ((current.visited & DFSNode.VISTED_LEFT) != 0 )) 
		{
			current.visited = (byte) (current.visited | DFSNode.VISTED_LEFT) ;
			return 'L';
		}
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
	}
}


