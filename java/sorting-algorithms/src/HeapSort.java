/**
 * Cormen's heap sort algorithm
 * 
 * @author Eren Türkay <turkay.eren@gmail.com>
 *
 */

import java.util.Arrays;

public class HeapSort implements SortIntArray{
	
	private int[] arrayToSort;
	private int arrayLength;
	private int heapSize;
	
	public void sortIntArray(int[] A) {
		this.arrayLength = A.length;
		this.arrayToSort = A;
		this.heapSize = A.length;
		
		this.heapSort();
	}
	
	/**
	 * Helper function for accessing parent element in array.
	 * 
	 * @param i Indice to get parent of
	 * @return Indice of the parent element
	 */
	
	public double parent(double i) {
		return Math.floor(i);
	}
	
	/**
	 * Helper function for accessing left element in array.
	 * 
	 * @param i Indice to get left element o
	 * @return Indice of the left element
	 */
	public static int left(int i) {
		if (i == 0)
			return 1;
		else
			return (2*i)+1;
	}
	
	/**
	 * Helper function for accessing right element in array.
	 * 
	 * @param i Indice to get right element o
	 * @return Indice of the right element
	 */
	public static int right(int i) {
		if (i == 0)
			return 2;
		else
			return (2*i) + 2;
	}

	/**
	 * An helper function that exchanges the values in the array
	 * 
	 * Give indices i and j, it exchanges the values of this.arrayToSort
	 * 
	 * @param i Indices to exchange
	 * @param j Indices to exchange
	 */
	public void exchange(int i, int j) {
		int tmp = this.arrayToSort[i];
		this.arrayToSort[i] = this.arrayToSort[j];
		this.arrayToSort[j] = tmp;
	}
	
	/**
	 * A function for arranging arrays in order to make sure that
	 * our array is a max heap.
	 * 
	 * Our assumption is that all the leaves of i are max heaps but
	 * the i itself would not be a max-heap. This function places the
	 * element in i-th position on the leaf so that it is max-heap
	 * 
	 * @param i An indice to start
	 */
	public void maxHeapify(int i) {
		
		int l = left(i);
		int r = right(i);
		int largest;
		
		if (l < this.heapSize && this.arrayToSort[l] > this.arrayToSort[i])
			largest = l;
		else
			largest = i;
		
		if (r < this.heapSize && this.arrayToSort[r] > this.arrayToSort[largest]) 
			largest = r;
		
		if (largest != i) {
			this.exchange(i, largest);
			this.maxHeapify(largest);
		}
	}
	
	/**
	 * A function for building max heap.
	 * 
	 * This builds an array accordingly to our definition of max heap.
	 */
	
	public void buildMaxHeap() {
		int middle = (int) Math.floor(this.arrayLength / 2);
		
		for (int i = middle; i >= 0; i--) {
			this.maxHeapify(i);
		}
	}
	
	/**
	 * A function for sorting the array.
	 * 
	 * It creates max heap and recursively max heapifies until
	 * all the list is sorted
	 * 
	 */
	public void heapSort() {
		this.buildMaxHeap();
		
		for (int i = this.arrayLength-1; i >= 1; i--) {
			this.exchange(0, i);
			this.heapSize--;
			this.maxHeapify(0);
		}
	}

	public static void main(String[] arg) {
		int[] b = {16, 14, 10, 8, 7, 9, 3, 2, 4, 1};
		int[] a = {20, 8, 10, 1, 5, 2, 6, 4};

		HeapSort srt = new HeapSort();
		srt.sortIntArray(a);
		
		System.out.println(Arrays.toString(a));
	}
}
