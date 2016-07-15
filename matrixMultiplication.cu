
#include<stdio.h>
#define BLOCK_DIM 1
#define N 16
__global__ void matmul(int *a, int *b, int *c, int width)
{
 int k, sum=0;
 int col=blockIdx.x*blockDim.x+threadIdx.x;
 int row=blockIdx.y*blockDim.y+threadIdx.y;
 if(col<width && row<width){
  for(k=0;k<width;k++){
   sum+=a[row*width+k]*b[k*width+col];
   c[row*width+col]=sum;
  }
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
 matmul<<<dimGrid,dimBlock>>>(d_a,d_b,d_c,N);
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
