import java.util.Random;

class TestSort
{
    static int[] randomArray(int len) 
    {
        Random r = new Random();
        int[] a = new int[len];
        for(int i = 0; i < len; i++) 
                a[i] = r.nextInt(len);
        return a;
    }

    static int[] orderedArray(int len) 
    {
        int[] a = new int[len];
        for(int i = 0; i < len; i++) 
                a[i]=i;
        return a;
    }

    /**
       Helper function to print an array for debugging purposes
    */
    static void printArray(int[] a, String msg) 
    {
        System.console().format("%s ( ", msg);
        for (int i=0; i<a.length;i++) 
            System.console().format("%d ",a[i]);
        System.console().format(" )\n");
    }
    
    static boolean isSorted(int[] arr)
    {
        int i;
        for (i = 0 ; i < arr.length - 1 ; i++)
            if (arr[i] > arr[i+1])
                return false;
        return true;
    }   
    
    public static int[] cloneArray(int[]arr)
    {   
        int i;
        int [] clone = new int[arr.length];
        for (i = 0;i < arr.length; i++)
            clone[i] = arr[i];
        return clone;
    }
 
    static void testOneSort(int[] a, SortIntArray as, String sortName) 
    {
        long startTime=System.currentTimeMillis();
        as.sortIntArray(a);        
        long endTime=System.currentTimeMillis();
        if (isSorted(a))
        {
            System.console().format(sortName + " time = %d \n", endTime-startTime);
        }
        else
        {
            System.console().format(
                "%s sort failed\n", sortName);
            printArray(a,"Broken Array: ");
        }
    }
    
    /**
       Main function to test algorithms 
	command line input is a list of array sizes to test.
    */
    public static void main(String[] args) 
    {
        int len,i;
        int[] a;
        if (args.length < 1)
        {
            System.console().format("Command line is java TestSort <sizetosort> ... ");
            return;
        }
        /*
        CSV style output headers
        */
        System.console().format("(c)Chris Stephenson 2008-2011\n" );
        for (i = 0; i < args.length ; i++)
        {
            len = Integer.parseInt(args[i]);
            System.console().format("Length = %d\n", len);
            a=randomArray(len);
            testOneSort(cloneArray(a),new InsertSort(),"Insert");
            testOneSort(cloneArray(a),new MergeSort(), "Merge");
/*
            testOneSort(cloneArray(a),new CormenMergeSort(), "Cormen Merge");// Implement this
            testOneSort(cloneArray(a),new QuickSort(), "Quick");// Implement this
            testOneSort(cloneArray(a),new HeapSort(), "Heap");// ımplement this if you have time and inclination, for bonus points.
*/
            System.console().format("\n");
        }
    }
}
