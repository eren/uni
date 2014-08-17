/**
 * 
 * @author Eren Türkay <turkay.eren@gmail.com>
 */

public class NodeRB<Key extends Comparable<Key>, Value> extends Node<Key, Value> {

	private String color;
	
	/**
	 * Construct the class.
	 * 
	 * @param key Key for the node
	 * @param val Value associated with the key
	 */
	public NodeRB(Key key, Value val) {
		super(key, val);
		this.color = "black";
	}
	
	public String getColor() {
		return this.color;
	}
	
	public void setColor(String color) {
		this.color = color;
	}

	@Override
	public String toString() {
		// Override it to add color information.
		return String.format("(Node'%s' [c=%s, left=%s, right=%s])",
				this.getKey(),
				this.color,
				this.getLeft(),
				this.getRight());
	}

	public static void main(String[] args) {
		NodeRB<Integer, String> rb1 = new NodeRB<Integer, String>(10, "on");
		NodeRB<Integer, String> rb2 = new NodeRB<Integer, String>(15, "onbes");
		
		System.out.println(rb1.compareTo(rb2));
	}
	
}
