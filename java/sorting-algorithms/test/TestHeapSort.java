import static org.junit.Assert.*;

import org.junit.Test;

public class TestHeapSort {
	@Test
	public void testSort() {
		HeapSort hsort = new HeapSort();

		int[] A = {1,2,3,4,5};
		int[] AExpected = {1,2,3,4,5};
		
		int[] B = {1,1,2,2,3,3,4,4,5};
		int[] BExpected = {1,1,2,2,3,3,4,4,5};
		
		int[] C ={6,5,3,1,8,7,2,4,3,5,5};
		int[] CExpected = {1, 2, 3, 3, 4, 5, 5, 5, 6, 7, 8};
		
		hsort.sortIntArray(A);
		hsort.sortIntArray(B);
		hsort.sortIntArray(C);
		
		assertArrayEquals(A, AExpected);
		assertArrayEquals(B, BExpected);
		assertArrayEquals(C, CExpected);

	}
	
	@Test
	public void testRandom() {
		HeapSort hsort = new HeapSort();

		int[] rnd = TestSort.randomArray(15);
		hsort.sortIntArray(rnd);
		
		assertTrue(TestSort.isSorted(rnd));
		
	}
	
	@Test
	public void testOrdered() {
		HeapSort hsort = new HeapSort();

		int[] order = TestSort.orderedArray(15);
		hsort.sortIntArray(order);
		
		assertTrue(TestSort.isSorted(order));
	}
}
