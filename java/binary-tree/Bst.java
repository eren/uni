/**
 * 
 * @author Eren Türkay <turkay.eren@gmail.com>
 */

public class Bst<Key extends Comparable<Key>, Value> {
	private Node<Key, Value> root;

	public Bst(Node<Key, Value> root) {
		this.root = root;
	}
	
	public void setRoot(Node<Key, Value> r) {
		this.root = r;
	}
	
	public Node<Key, Value> getRoot() {
		return this.root;
	}
	
	public String toString() {
		return this.root.toString();
	}
	
	/**
	 * Insert the value to the appropriate position in BST.
	 * 
	 * @param node Node to insert.
	 */
	public void insert(Node<Key,Value> node) {		
		/*
		 * Iterate over the nodes to find an appropriate
		 * node to insert. I am keeping previous node
		 * because of the while loop. When while loop ends,
		 * tmp value is set to null so I cannot know which node
		 * to insert to. Prev value points to the previous node
		 * in while loop. So, I can get the node to insert when
		 * while loop ends.
		 */	
		Node<Key, Value> prev = null;
		Node<Key, Value> tmp = this.root;
		while (tmp != null) {
			prev = tmp;
			/*
			 * our node is greater than the root, meaning we should place
			 * it on the right side of the root and iterate again.
			 */
			if (node.compareTo(tmp) >= 0)
				tmp = tmp.getRight();
			else
				tmp = tmp.getLeft();
		}
		
		if (node.compareTo(prev) >= 0)
			prev.setRight(node);
		else
			prev.setLeft(node);
			
	}
	
	/**
	 * Find the node accordingly to its key
	 * 
	 * @param key Key to search for.
	 * @return The complete node whose key is "key"
	 */
	public Node<Key, Value> find(Key key) {
		/*
		 * Iterate over the binary search tree.
		 */
		Node<Key, Value> tmp = this.root;
		while (tmp != null) {
			if (tmp.getKey().compareTo(key) == 0)
				return tmp;

			// key is greater than our tmp. Go to the right branch and start again
			if (key.compareTo(tmp.getKey()) >= 0)
				tmp = tmp.getRight();
			else
				// key is lesser than our tmp. Go to the left branch and start again.
				tmp = tmp.getLeft();
		}
		
		// if we haven't found in main loop, it means that it does not exist.
		return null;			
	}
	
	/**
	 * Find the node whose value is minimum.
	 *
	 * This method is for the case #3 in the removal of the node, when the
	 * node has 2 children.
	 * 
	 * @param n Node to get the minimum in its right branch
	 * @return Node that is a minimum 
	 */
	private Node<Key, Value> findMinimumInRightNode(Node<Key, Value> n) {
		Node<Key, Value> right = n.getRight();
		
		/*
		 *  It does not have a left node, which should be lesser
		 *  than the right node. So, the minimum is the right node
		 *  itself.
		 */
		if (right.getLeft() == null)
			return right;
		
		// Iterate all the left nodes
		while (right.getLeft() != null) {
			right = right.getLeft();
		}
		
		return right;
		
	}
	
	public void remove(Key k) {
		Node<Key, Value> currentNode = this.find(k);
		Node<Key, Value> left = currentNode.getLeft();
		Node<Key, Value> right = currentNode.getRight();
		Node<Key, Value> parent = currentNode.getParent();
		
		/*
		 *  Case #1, Node has no children. So remove directly
		 */
		
		if (left == null && right == null) {
			currentNode.remove();
		}
		/*
		 * Case 2. Node has either left or right. Bind the node's child
		 * to the parent node.
		 */
		else if (left == null && right != null){
			if (currentNode.getPositionInParent() == "right")
				parent.setRight(right);
			else
				parent.setLeft(right);
				
			return;
		}
		else if (left != null && right == null){
			// determine whether to bind on root's left or right
			if (currentNode.getPositionInParent() == "right")
				parent.setRight(left);
			else
				parent.setLeft(left);
			
			return;
		}
		else if (left != null && right != null) {
			/*
			 * Case #3. Node has 2 child. Find the minimum in its right node
			 * and replace its value with current node. Afterwards, delete
			 * the duplicate.
			 */
			Node<Key, Value> minRight = this.findMinimumInRightNode(currentNode);
			
			currentNode.setValue(minRight.getValue());
			currentNode.setKey(minRight.getKey());
			// remove the duplicate entry
			minRight.remove();

			return;
		}
	}
	
	
	/**
	 * Rotate the tree rooted at node by left. Consider we have a tree
	 * structure like this:
	 * 
	 *  A
	 *   \
	 *    B
	 *  /  \
	 * D    C
	 *      
	 * After the rotation, it will become
	 * 
	 *	B
	 *     / \
	 *    A   C
	 *     \
	 *      D
	 *      
	 *  - B becomes the new root.
	 *  - A takes ownership of b's left child as its right child.
	 *  - B takes ownership of a as its left child. 
	 *  
	 * @param node Node to rotate
	 */
	public void rotateLeft(Node<Key, Value> node) {
		Node<Key, Value> right = node.getRight();
		
		// copy our original node with its left branch
		Node<Key, Value> original = new Node<Key, Value>(node.getKey(), node.getValue());
		original.setLeft(node.getLeft());
		
		// make our right node the new root
		node.setValue(right.getValue());
		node.setKey(right.getKey());
		
		// bind right node's left child to our original node as a right child
		original.setRight(right.getLeft());
		
		// bind our original node as a left of the new root.
		node.setLeft(original);
		// bind new root's right child
		node.setRight(right.getRight());
 
	}
	
	/**
	 * Rotate the tree rooted at node by left. Consider we have a tree
	 * structure like this:
	 * 
	 *     D
	 *    / \
	 *   B   F
	 *  / \
	 * C   A
	 *  
	 * It will become:
	 * 
	 *	B
	 *     / \
	 *    C   D
	 *  	 / \
	 *      A   F
	 * 
	 * - B becomes the new root
	 * - D takes the ownership of B's right child as its left child
	 * - B takes the ownership of D as its right child. 
	 * 
	 * @param node
	 */
	public void rotateRight(Node<Key, Value> node) {
		Node<Key, Value> left = node.getLeft();
		
		// copy our original node with its right branch.
		Node<Key, Value> original = new Node<Key, Value>(node.getKey(), node.getValue());
		original.setRight(node.getRight());
		
		// make our left node the new root
		node.setValue(left.getValue());
		node.setKey(left.getKey());
		
		// bind left node's right child to our original node as a left child
		original.setLeft(left.getRight());
		
		// bind our original node as a right child of the new root.
		node.setRight(original);
		// bind new root's left child
		node.setLeft(left.getLeft());
 
	}
	
	public static void main(String[] args) {
		Bst<Integer, String> bst = new Bst<Integer, String>(new Node<Integer, String>(30, "Otuz"));
		bst.insert(new Node<Integer,String>(20, "Yirmi"));
		bst.insert(new Node<Integer,String>(10, "On"));
		bst.insert(new Node<Integer,String>(11, "Onbir"));
		bst.insert(new Node<Integer,String>(25, "yirmibes"));
		bst.insert(new Node<Integer,String>(5, "bes"));
		bst.insert(new Node<Integer,String>(50, "elli"));
		
		System.out.println(bst);
		bst.rotateRight(bst.getRoot());
		System.out.println(bst);
		
		/*Bst bst = new Bst(new Node(30));
		bst.insert(35);
		bst.insert(20);
		bst.insert(25);
		bst.insert(15);
		bst.insert(27);
		bst.insert(26);
		bst.insert(28);
		bst.insert(10);
		bst.insert(9);
		bst.insert(11);
		
		System.out.println(bst);
		bst.remove(25);
		System.out.println(bst);*/
		
	}
	
}
