/**
 * Red Black node implementation
 * 
 * @author Eren Türkay <turkay.eren@gmail.com>
 *
 * @param <Key> Type of the key in node
 * @param <Value> Type of the value in node
 */

public class RedBlack<Key extends Comparable<Key>, Value> extends Bst<Key, Value> {
	public RedBlack(NodeRB<Key, Value> node) {
		super(node);
	}

	/**
	 * Insert the value to the appropriate position in BST.
	 * 
	 * This method uses normal insert procedure defined in BST, however
	 * fixes the tree after the insertion to maintain red-black property.
	 * 
	 * @param node Node to insert.
	 */
	@Override
	public void insert(Node<Key,Value> node) {	
		super.insert(node);
		// this.fixup();
	}

	public static void main(String[] args) {
		RedBlack<Integer, String> rb = new RedBlack<Integer, String>(new NodeRB<Integer, String>(30, "Otuz"));
		
		rb.insert(new NodeRB<Integer,String>(20, "Yirmi"));
		
		System.out.println(rb);
	}
	
}