int main(){
  int a[3][3],i,j;
  int determinant=0;


  for(i=0;i<3;i++)
      determinant = determinant + (a[0][i]*(a[1][(i+1)%3]*a[2][(i+2)%3] 
                              - a[1][(i+2)%3]*a[2][(i+1)%3]));

   return 0;
}
