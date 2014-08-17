import static org.junit.Assert.*;

import org.junit.Test;

public class TestQuickSort {
	@Test
	public void testSort() {
		QuickSort qsort = new QuickSort();

		int[] A = {1,2,3,4,5};
		int[] AExpected = {1,2,3,4,5};
		
		int[] B = {1,1,2,2,3,3,4,4,5};
		int[] BExpected = {1,1,2,2,3,3,4,4,5};
		
		int[] C ={6,5,3,1,8,7,2,4,3,5,5};
		int[] CExpected = {1, 2, 3, 3, 4, 5, 5, 5, 6, 7, 8};
		
		qsort.sortIntArray(A);
		qsort.sortIntArray(B);
		qsort.sortIntArray(C);
		
		assertArrayEquals(A, AExpected);
		assertArrayEquals(B, BExpected);
		assertArrayEquals(C, CExpected);

	}
	
	@Test
	public void testRandom() {
		QuickSort qsort = new QuickSort();

		int[] rnd = TestSort.randomArray(15);
		qsort.sortIntArray(rnd);
		
		assertTrue(TestSort.isSorted(rnd));
		
	}
	
	@Test
	public void testOrdered() {
		QuickSort qsort = new QuickSort();

		int[] order = TestSort.orderedArray(15);
		qsort.sortIntArray(order);
		
		assertTrue(TestSort.isSorted(order));
	}
}