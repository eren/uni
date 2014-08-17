/*
 * Chris Stephenson <cs@cs.bilgi.edu.tr>, 2011
 */

class InsertSort implements SortIntArray
{

/*    public void sortIntArray(int[] a) // Cormen version for comparison
    {
        int i,j,key;
        for (i = 1; i < a.length; i++) 
        {
            key = a[i];
            for (j = i-1; (j >= 0) && (a[j] > key); j--)
                a[j+1] = a[j];
            a[j+1] = key;
        }
    }
*/


/* recursive structure, mutative implementation. Try it for n>5000 and you may see stack overflow */

/* data definitions and design steps done in the lecture omitted. Anyone who submits them can get extra points */

/*
void insert (int toInsert, int[] a, int start, int end)
{
	if (start == end - 1)
		a[start] = toInsert;
	else if (toInsert < a[start+1])
		a[start] = toInsert;
	else 
	{
		a[start] = a[start + 1];
		insert (toInsert, a, start+1, end);
	}	
}

void sortIntArraySegment(int[] a, int start, int end)
{
	if (start < end - 1)
	{
		sortIntArraySegment(a, start + 1, end);
		insert (a[start], a, start , end);
	}
}

public void sortIntArray(int[]a)
{
	sortIntArraySegment(a, 0, a.length);
}
*/
/* end of recursive structure, mutative implementation. Try it for n>5000 and you may see stack overflow */



/* recursive structure with the recursions unwound into loops*/
void insert (int toInsert, int[] a, int start, int end)
{
/*	if ((start == end - 1) || (toInsert < a[start+1])) //original recursive structure
		a[start] = toInsert;
	else 
	{
		a[start] = a[start + 1];
		insert (toInsert, a, start+1, end);
	}	
*/
	while ((start < end -1) && (toInsert > a[start+1])) //tail recursion into  loop
	{
		a[start] = a[start + 1];
		start++;
	}
	a[start] = toInsert;		
}

void sortIntArraySegment(int[] a, int start, int end)
{
/*
	if (start < end - 1) //original recursion - note not tail recursive - need to reverse order
	{
		sortIntArraySegment(a, start + 1, end);
		insert (a[start], a, start , end);
	}
*/
	int pos = end-1;
	while (pos >= start)
	{
		insert (a[pos], a, pos , end);
		pos--;
	}

}

public void sortIntArray(int[]a)
{
	sortIntArraySegment(a, 0, a.length);
}
/* end of recursive structure with the recursions unwound into loops*/


}
