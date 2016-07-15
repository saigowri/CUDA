#include<stdio.h>
__global__ void cube(int * a, int * b)
{
 int id=blockIdx.x*blockDim.x+threadIdx.x;
 b[id]=a[id]*a[id]*a[id];
}
#define N 25
#define B 5
int main(void)
{
int a[N],b[N];
int *d_a,*d_b;
for(int i=0;i<N;i++)
{
  a[i]=int(i);
}
cudaMalloc((void **)&d_a,N*sizeof(int));
cudaMalloc((void **)&d_b,N*sizeof(int));
cudaMemcpy(d_a,a,N*sizeof(int),cudaMemcpyHostToDevice);
cube<<<N/B,B>>>(d_a,d_b);
cudaMemcpy(b,d_b,N*sizeof(int),cudaMemcpyDeviceToHost);
for(int i=0;i<N;i++)
{
printf("Cube of %d = %d\n",a[i],b[i]);
}
cudaFree(d_a);
cudaFree(d_b);
return 0;
}
