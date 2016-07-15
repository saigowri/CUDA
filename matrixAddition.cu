#include<stdio.h>
#define BLOCK_DIM 25
#define N 25
__global__ void matadd(int *a, int *b, int *c)
{
 int col=blockIdx.x*blockDim.x+threadIdx.x;
 int row=blockIdx.y*blockDim.y+threadIdx.y;
 int index = col + row*N;
 if(col<N && row<N){
   c[index]=a[index]+b[index];
 }
}
int main(void)
{
 int a[N][N],b[N][N],c[N][N];
 int *d_a,*d_b,*d_c;
 int size = sizeof(int) * N * N;
 printf("Elements of matA\n");
 for(int i=0;i<N;i++)
 {
  for(int j=0;j<N;j++)
  {
    a[i][j]=i;
    printf("%d\t",a[i][j]);
  }
  printf("\n");
 }
 printf("Elements of matB\n");
 for(int i=0;i<N;i++)
 {
  for(int j=0;j<N;j++)
  {
    b[i][j]=j;
    printf("%d\t",b[i][j]);
  }
  printf("\n");
 }
 printf("\n");
 cudaMalloc((void **)&d_a,size);
 cudaMalloc((void **)&d_b,size);
 cudaMalloc((void **)&d_c,size);
 cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
 cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);
 dim3 dimBlock(BLOCK_DIM,BLOCK_DIM);
 dim3 dimGrid((int)(N/dimBlock.x),(int)(N/dimBlock.y));
 matadd<<<dimGrid,dimBlock>>>(d_a,d_b,d_c);
 cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
 printf("Elements of MatC\n");
 for(int i=0;i<N;i++)
 {
  for(int j=0;j<N;j++)
  {
    printf("%d\t",c[i][j]);
  }
  printf("\n");
 }
 cudaFree(d_a);
 cudaFree(d_b);
 cudaFree(d_c);
 return 0;
}
