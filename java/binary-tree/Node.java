/**
 * 
 * @author Eren Türkay <turkay.eren@gmail.com>
 */

public class Node<Key extends Comparable<Key>, Value> implements Comparable<Node<Key, Value>> {

	private Node<Key, Value> left;
	private Node<Key, Value> right;
	private Node<Key, Value> parent;
	private Key key;
	private Value value;
	
	public Node(Key key, Value value) {
		this.left = null;
		this.right = null;
		this.parent = null;
		this.key = key;
		this.value = value;
	}

	@Override
	public String toString() {
		return String.format("(Node'%s' [left=%s, right=%s])",
				this.key,
				this.left,
				this.right);
	}

	public int compareTo(Node<Key, Value> other) {
		/*
		 *  Comparing the keys is sufficient. We know that the key
		 *  will have compareTo() method as we force it to extend
		 *  Comparable object in our Node definition.
		 */
		return this.key.compareTo(other.key);
	}
	
	public Node<Key, Value> getLeft() {
		return left;
	}

	public void setLeft(Node<Key, Value> left) {
		if (left == null)
			this.left = null;
		else {
			this.left = left;
			left.setParent(this);
		}
	}

	public Node<Key, Value> getRight() {
		return right;
	}

	public void setRight(Node<Key, Value> right) {
		if (right == null)
			this.right = null;
		else {
			this.right = right;
			right.setParent(this);
		}
	}

	public Node<Key, Value> getParent() {
		return parent;
	}

	public void setParent(Node<Key, Value> parent) {
		this.parent = parent;
	}

	public Value getValue() {
		return value;
	}

	public void setValue(Value value) {
		this.value = value;
	}
	
	public Key getKey() {
		return key;
	}
	
	public void setKey(Key key) {
		this.key = key;
	}

	/**
	 * Get the position of the node with respect to its parent. If the node
	 * is greater than or equal to its parent, it means, by the definition
	 * of our BST, that the node lies on the right of its parent. Otherwise,
	 * on its left. 
	 * 
	 * @return left or right
	 */
	public String getPositionInParent() {
		/*
		 * Find where this node lies on parent node. Left or right.
		 * 
		 * If the object is greater (1) than or equal (0) to its parent,
		 * it means that it lies on the parent's right.
		 */
		
		if (this.compareTo(this.parent) == 0 || this.compareTo(this.parent) == 1)
			return "right";
		else
			return "left";
	}
	
	/**
	 * Remove the node from the BST. Basically, I find out the node's
	 * parent and set this parent's left or right to null.
	 */
	public void remove() { 
		/*
		 * Find where this node lies on parent node. Left or right.
		 * 
		 * If the object is greater (1) than or equal (0) to its parent,
		 * it means that it lies on the parent's right.
		 */
		
		if (this.getPositionInParent() == "right")
			this.parent.setRight(null);
		else
			this.parent.setLeft(null);
	}
	
	public static void main(String[] args) {
		Node<Integer, String> root = new Node<Integer,String>(30, "Otuz");
		Node<Integer, String> n = new Node<Integer,String>(40, "Kirk");
		Node<Integer, String> m = new Node<Integer,String>(10, "On");
		
		root.setRight(n);
		root.setLeft(m);
	
		System.out.println(root.compareTo(n));
		System.out.println(n.getPositionInParent());
		System.out.println(m.getPositionInParent());
		m.remove();
		System.out.println(root);

		
	}
}
