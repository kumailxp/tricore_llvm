int prime(int n, count, c)
{
   int i = 3;
 
   for ( count = 2 ; count <= n ;  )
   {
      for ( c = 2 ; c <= i - 1 ; c++ )
      {
         if ( i%c == 0 )
            break;
      }
      if ( c == i )
      {
         count++;
      }
      i++;
   }
 
   return 0;
}
