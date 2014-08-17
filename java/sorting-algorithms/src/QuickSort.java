/*
 * Eren Turkay <turkay.eren@gmail.com>
 * 2011
 */

import java.util.Arrays;

public class QuickSort implements SortIntArray {

	private int[] arrayToSort;
	private int arrayLength;
	
	/**
	 * A main method that sorts the given list.
	 * 
	 * It implements SortIntArray class and does in-place sorting.
	 * It means that we do not return a new array. Instead, we operate
	 * on the given list.
	 * 
	 * @param array Array of integers to sort
	 * @return void
	 */
	
	public void sortIntArray(int[] array) {
		// now I'm checking null values
		if (array == null || array.length == 0)
			return;
		
		this.arrayToSort = array;
		this.arrayLength = array.length;
	
		// start sorting with indices i=0 and j=end of the array.
		quicksort(0, arrayLength-1);
	}
	
	/**
	 * Actual quicksort algorithm.
	 * 
	 * It operates in the following way:
	 * 
	 * 1- Select an element from the array called pivot element. It is the element
	 *    in the middle of the array
	 * 2- All elements smaller than pivot element are placed on the left-side of pivot.
	 * 3- All elements greater than pvot element are places on the right-side of pivot.
	 * 4- Recursively apply 
	 * @param left
	 * @param right
	 */
	
	private void quicksort(int left, int right) {
		int i = left, j = right;

		// select the pivot element
		int pivot = this.arrayToSort[left + (right-left)/2];

		while (i <= j) {
			// iterate until an element greater than pivot
			while (this.arrayToSort[i] < pivot) {
				i++;
			}

			// iterate until an element less than pivot
			while (this.arrayToSort[j] > pivot) {
				j--;
			}

			/* If we found elements on both left and right side, we exchange them.
			 * Remember that on the left site the elements smaller than pivot should exist
			 * and on the right side the elements greater than pivot exist.
			 */
			if (i <= j) {
				exchange(i, j);
				i++;
				j--;
			}
		}
		
		// Recursion step.
		if (left < j)
			quicksort(left, j);
		if (i < right)
			quicksort(i, right);
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
	
	public static void main(String[] args) {
		QuickSort srt = new QuickSort();
		int[] arrays = {12, 13, 2, 10, 7, 12, 13, 0, 14, 13, 0, 5, 12, 12, 0};
		srt.sortIntArray(arrays);
		
		int[] foo = TestSort.randomArray(15);
		System.out.println(Arrays.toString(foo));
		srt.sortIntArray(foo);
		System.out.println(Arrays.toString(foo));

		
		
		System.out.println(Arrays.toString(arrays));
		
		int[] f = {6,5,3,1,8,7,2,4};
		System.out.println(f.length);
		System.out.println((7/2));
	}
}
