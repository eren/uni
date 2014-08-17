/*
 * Chris Stephenson <cs@cs.bilgi.edu.tr>, 2011
 *
 */

class MergeSort   implements SortIntArray
{
    public void sortIntArray(int[] array)
    {
        int[] working = new int[array.length];
        for (int i = 0; i < array.length; i++)
            working[i] = array[i];
        mergeSort (array, working, 0, array.length);
    }  

/*
You may find it instructive to compare this implementation of merge
with the version in Cormen. Cormen's version involves n-1 memory allocations to sort an array of length n and allocates a total memory of O(n log n). This version performs a single memory allocation of size O(n).

Cormen's version also uses the extremely ugly and unnecessary idea of sentinels

The key to this difference is the idea of an "array segment" as our data definition.
*/ 


/* 
	merge arraysegment arraysegment -> void 

	this method merges contiguous arraysegments in the from array to an 
	arraysegment in the same position in the to array.  
	from: array of int is the source array
	to: array of int is the destination array
	start1: int is the start index of the first input array segment and the output array segement
	mid: int is the end index of the first input array segment and the start index of the second
		input array segment
	end2: int is the end index of the output array segment and the second input array segment.
*/

    void merge (int[] from, int[] to, 
                int start1, int mid, int end2)    
    {
        int outputindex = start1;
	int end1 = mid;
	int start2 = mid;
        while ((start1 < end1) && (start2 < end2))
            if (from[start1] <= from[start2])
                to[outputindex++] = from[start1++];
            else
                to[outputindex++] = from[start2++];
        while (start1 < end1)
            to[outputindex++] = from[start1++];
        while (start2 < end2)
            to[outputindex++] = from[start2++];
    }
    
    /**
	mergeSort array of int, array of int, int, int -> void

        purpose: merge sort a segment of the given input array

	input,start,end: the array segment to be sorted in place. The result will be placed here.

	working: an array guaranteed to contain, within the limits of the input segment, a copy
	of input at the entry to mergeSort. Note that mergeSort must preserve this condition 
	when it makes a recursive call. Check that it does so and note the importance of the reversal 		of working and input in the recursive calls.
	
     */
    void mergeSort (int[] input, int[]working, 
                            int start, int end) 
    {
        if (start < end - 1) 
        {
            int mid = start + (end-start)/2; // avoiding potential arithmetic overflow on large arrays!
            mergeSort(working, input, start, mid);
            mergeSort(working, input, mid, end);
            merge(working, input, start, mid, end);   
        }
    }
    
}
