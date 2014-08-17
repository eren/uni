import static org.junit.Assert.*;

import org.junit.Test;

public class TestMergeSort {
	@Test
	public void testSort() {
		MergeSort msort = new MergeSort();

		int[] A = {1,2,3,4,5};
		int[] AExpected = {1,2,3,4,5};
		
		int[] B = {1,1,2,2,3,3,4,4,5};
		int[] BExpected = {1,1,2,2,3,3,4,4,5};
		
		int[] C ={6,5,3,1,8,7,2,4,3,5,5};
		int[] CExpected = {1, 2, 3, 3, 4, 5, 5, 5, 6, 7, 8};
		
		msort.sortIntArray(A);
		msort.sortIntArray(B);
		msort.sortIntArray(C);
		
		assertArrayEquals(A, AExpected);
		assertArrayEquals(B, BExpected);
		assertArrayEquals(C, CExpected);

	}
	
	@Test
	public void testRandom() {
		MergeSort msort = new MergeSort();

		int[] rnd = TestSort.randomArray(15);
		msort.sortIntArray(rnd);
		
		assertTrue(TestSort.isSorted(rnd));
		
	}
	
	@Test
	public void testOrdered() {
		MergeSort msort = new MergeSort();

		int[] order = TestSort.orderedArray(15);
		msort.sortIntArray(order);
		
		assertTrue(TestSort.isSorted(order));
	}
}
