/**
 * 
 * @author Eren Türkay <turkay.eren@gmail.com>
 */


public class AVL<Key extends Comparable<Key>, Value> extends Bst<Key, Value> {
	public AVL(Node<Key, Value> n) {
		super(n);
	}
	
	/**
	 * Get the depth of a node
	 * 
	 * A node which does not have any child will be counted as 1.
	 * So, the depth information is inclusive. The node itself is
	 * also counted.
	 * 
	 * @param node Node to get the depth of
	 * @return Depth of the node
	 */
	private int depth(Node<Key, Value> node) {
		// Get right branch's depth first.
		Node<Key, Value> tmp_right = node;
		int right_count = 0;
		
		while (tmp_right != null) {
			tmp_right = tmp_right.getRight();
			right_count++;
		}
		
		// get left branch's depth
		Node<Key, Value> tmp_left = node;
		int left_count = 0;
		while (tmp_left != null) {
			tmp_left = tmp_left.getLeft();
			left_count++;
		}
		
		return Math.max(right_count, left_count);	
	}
	
	/**
	 * Get the balance factor.
	 * 
	 * The balance factor is used in fixing the unbalanced tree.
	 * Any tree that has a balance factor of >= +-2 is called an
	 * unbalanced tree. +2 and greater balance factor means that the tree is
	 * heavier on left, -2 and lesser means heavier on right.
	 * 
	 * Note that although this method can give values greater than 2
	 * or lesser than -2, only -2 and +2 are used in fixTree(). This is
	 * because whenever a node is inserted or deleted, every parent node
	 * beginning from the inserted/deleted node is checked accordingly
	 * to its balance factor. So, the method does not hit the values other
	 * than -2 or +2
	 * 
	 * @param node Node to compute the balance factor.
	 * @return Balance factor.
	 */
	private int balanceFactor(Node<Key, Value> node) {
		return this.depth(node.getLeft()) - this.depth(node.getRight());
	}
	
	private void fixTree(Node<Key, Value> node) {
		if (node == null)
			return;
		
		int bf = this.balanceFactor(node);
		
		if (bf == -2) {
			if (this.balanceFactor(node.getRight()) == -1)
				this.rotateLeft(node);
			else {
				this.rotateRight(node.getRight());
				this.rotateLeft(node);
			}
		}
		else if (bf == 2) {
			if (this.balanceFactor(node.getLeft()) == 1)
				this.rotateRight(node);
			else {
				this.rotateLeft(node.getLeft());
				this.rotateRight(node);
			}
		}
		
		// the node looks normal, iterate through its parent.
		this.fixTree(node.getParent());
	}
	
	public void insert(Node<Key, Value> node) {
		super.insert(node);
		this.fixTree(node.getParent());
	}
	
	public void remove(Key key) {
		/*
		 * I first get the reference to the parent because after the
		 * removal of the node, I cannot access its parent.
		 * 
		 */
		Node<Key, Value> parent = this.find(key).getParent();
		super.remove(key);
		this.fixTree(parent);
	}
	
	public static void main(String[] args) {
		AVL<Integer, String> avl = new AVL<Integer,String>(new Node<Integer,String>(30, "otuz"));
		
		avl.insert(new Node<Integer,String>(20, "Yirmi"));
		avl.insert(new Node<Integer,String>(10, "On"));
		avl.insert(new Node<Integer,String>(11, "Onbir"));
		avl.insert(new Node<Integer,String>(25, "yirmibes"));
		avl.insert(new Node<Integer,String>(5, "bes"));
		avl.insert(new Node<Integer,String>(50, "elli"));
		avl.insert(new Node<Integer,String>(70, "elli"));
		avl.insert(new Node<Integer,String>(80, "elli"));
		avl.insert(new Node<Integer,String>(90, "elli"));
		avl.insert(new Node<Integer,String>(100, "elli"));
		
		System.out.println(avl);
		avl.remove(10);
		System.out.println(avl);
		avl.remove(70);
		System.out.println(avl);
				
	}
	
}
