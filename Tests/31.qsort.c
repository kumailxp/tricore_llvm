typedef int size_t;
void swap(void *x, void *y, size_t l) {
   char *a = x, *b = y, c;
   while(l--) {
      c = *a;
      *a++ = *b;
      *b++ = c;
   }
}

int _cmp(char* a, char *b)
{
  int c = 0;
  while (a[c] == b[c]) {
      if (a[c] == '\0' || b[c] == '\0')
         break;
      c++;
   }
 
   if (a[c] == '\0' && b[c] == '\0')
      return 0;
   else
      return -1;
   return -1;
}

static void sort(char *array, size_t size, int (*cmp)(void*,void*), int begin, int end) {
   if (end > begin) {
      void *pivot = array + begin;
      int l = begin + size;
      int r = end;
      int index = l;
      while(l < r) {
         char g = array[index];
         if ( _cmp(&g, (char*)pivot) <= 0) {
            l += size;
            index = l;
         } else if ( _cmp(&g, (char*)pivot) > 0 )  {
            r -= size;
            index = r;
         } else if ( l < r ) {
            swap(array+l, array+r, size);
         }
      }
      l -= size;
      swap(array+begin, array+l, size);
      sort(array, size, cmp, begin, l);
      sort(array, size, cmp, r, end);
   }
}

// insertion sort stuff
void insertion_sort(int list[], int n)
{
    int i,j,temp;
    for (i = 1 ; i <= n - 1; i++)
    {
        j = i;

        while ( j > 0 && list[j] < list[j-1])
        {
            temp          = list[j];
            list[j]   = list[j-1];
            list[j-1] = temp;

            j--;
        }
    }

}

// selection sort stuff
void selection_sort(int list[], int n)
{
    int i,j,swap,position;

    for ( i = 0 ; i < ( n - 1 ) ; i++ )
    {

        position = i;

        for ( j = i + 1 ; j < n ; j++ )
        {
            if ( list[position] > list[j] )
                position = j;
        }
        if ( position != i )
        {
            swap = list[i];
            list[i] = list[position];
            list[position] = swap;
        }
    }


}

void qsort(void *array, size_t nitems, size_t size, int (*cmp)(void*,void*)) {
   sort(array, size, cmp, 0, nitems*size);
}

typedef int type;

int type_cmp(void *a, void *b){ return (*(type*)a)-(*(type*)b); }

int main(void){ /* simple test case for type=int */
  int num_list[]={5,4,3,2,1};
  int len=5;
  char *sep="";
  int i;
  qsort(num_list,len,4,type_cmp);
  selection_sort(num_list,5);
  insertion_sort(num_list,5);
  return 0;
}
