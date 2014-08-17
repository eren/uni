/**
 * 
 * A program for creating .dat file for graphing the time analysis.
 * 
 * @author Eren Türkay <turkay.eren@gmail.com>
 * @version 0.1
 *
 */

import java.io.*;

public class CreateGraph {
	public static long getAnalysis(SortIntArray algorithm, int[] A)
	{
		//System.gc();
		
		int[] cachedArray = TestSort.cloneArray(A);
		
		long startTime;
		long endTime;
		
		startTime = System.currentTimeMillis();
		algorithm.sortIntArray(cachedArray);
		endTime = System.currentTimeMillis();
		
		//System.gc();

		return endTime - startTime;
	}
	

	public static void main(String[] args) {		
		QuickSort quickSort = new QuickSort();
		CormenMergeSort cormenMergeSort = new CormenMergeSort();
		MergeSort mergeSort = new MergeSort();
		InsertSort insertSort = new InsertSort();
		HeapSort heapSort = new HeapSort();
		
		long quickSortTime, cormenMergeSortTime, mergeSortTime, insertSortTime, heapSortTime;
		
		try {
			FileWriter fstream = new FileWriter("random-heap-sort.dat");
			BufferedWriter out = new BufferedWriter(fstream);
			
			/*
			 * 1. column stands for number of inputs
			 * 		2. stands for quick sort
			 * 3. stands for merge sort
			 * 4. stands for cormen's merge sort
			 * 5. stands for insertion sort.
			 */
			
			for (int i=100; i<100000000; i=i*2) {
				int[] rnd = TestSort.orderedArray(i);
				
				System.out.printf("Testing for input size: %s\n", i);
				
				quickSortTime = getAnalysis(quickSort, rnd);
				cormenMergeSortTime = getAnalysis(cormenMergeSort, rnd);
				mergeSortTime = getAnalysis(mergeSort, rnd);
				heapSortTime = getAnalysis(heapSort, rnd);
				//insertSortTime = getAnalysis(insertSort, rnd);
				
				out.write(String.format("%s\t\t %s\t\t %s\t\t %s\t\t %s\n",
						i,
						quickSortTime,
						mergeSortTime,
						cormenMergeSortTime,
						heapSortTime
						));
				out.flush();
			}
			
			out.close();
			
			System.out.println("Done!");
			
			out.close();
		} catch (IOException e) {
			System.err.printf("Error: %s\n", e.getMessage());
		}
	}

}
