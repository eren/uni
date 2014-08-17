/*
 * Eren Turkay <turkay.eren@gmail.com>
 * 2011
 */

import java.util.Arrays;

public class CormenMergeSort implements SortIntArray {
	
	/**
	 * A main method that sorts the given list.
	 * 
	 * It implements SortIntArray class and does merge-sort accordingly
	 * to Cormen's book.
	 * 
	 * @param array Array of integers to sort
	 * @return void
	 */
	
	public void sortIntArray(int[] array) {
		// now I'm checking null values
		if (array == null || array.length == 0)
			return;
		
		/*
		 *  We start with the last element of the array as an end index.
		 *  It's why we substract 1 from the length.
		 */
		this.mergesort(array, 0, array.length - 1);
	}
	
	/**
	 * Merge part of the merge-sort algorithm in Cormen's book
	 * 
	 * The method merges two sorted arrays into one sorted array. It is
	 * assumed that A[p .. q] and A[q+1 .. r] is sorted, and p <= q < r
	 * 
	 * It re-arranges the array in-place. We do not return any new element.
	 * 
	 * @param A Array to combine.
	 * @param p Start indice of the first sorted array
	 * @param q End indice of the first sorted array
	 * @param r End indice of the second sorted array (typically the end indice of the whole array)
	 * 
	 */
	
	public void merge(int[] A, int p, int q, int r) {
		int left_length = q - p + 1;
		int right_length = r - q;
		
		int[] L = new int[left_length];
		int[] R = new int[right_length];
		
		// copy the subarrays into L and R
		for	(int i=0; i < left_length; i++) {
			L[i] = A[p + i];
		}
		
		for (int j=0; j < right_length; j++) {
			R[j] = A[q + j + 1];
		}
		
		int i = 0; // indice for left array
		int j = 0; // indice for right array
		
		for (int k=p; k <= r; k++) {
			/*
			 * The following 3 conditions is for implementing Cormen's awkward
			 * sentinels. Basically  with these checks, I copy the whole remaining
			 * elements in L to A if we consumed all elements in R, and vice-versa.
			 */
			if ((i >= left_length) && (j >= right_length))
				break;
			
			if (i >= left_length) {
				A[k] = R[j];
				j++;
			} 
			else if (j >= right_length) {
				A[k] = L[i];
				i++;
			} 
			else {
				if (L[i] <= R[j]) {
					A[k] = L[i];
					i++;
				}
				else {
					A[k] = R[j];
					j++;
				}
			}
		}
	}
	
	public void mergesort(int[] A, int p, int r) {

		if (p < r) {
			int q = (p + r) / 2;
			mergesort(A, p, q);
			mergesort(A, q+1, r);
			merge(A, p, q, r);
		}
	}

	public static void main(String[] args) {
		int[] f = {6,5,3,1,8,7,2,4,3,5,5};

		CormenMergeSort srt = new CormenMergeSort();
		
		srt.sortIntArray(f);
		//srt.merge(a, 3, 3, 4);
		System.out.println(Arrays.toString(f));
	}
}
