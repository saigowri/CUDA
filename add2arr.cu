#include<stdio.h>
__global__ void add(int *a, int *b, int *c)
{
 int id = threadIdx.x;
 c[id]=a[id]+b[id];
}
int main(void)
{
 const int a[5] = {1,2,3,4,5};
 const int b[5] = {10,20,30,40,50};
 int c[5];
 int *d_a,*d_b,*d_c;
 int size = sizeof(int)*5;
 cudaMalloc((void **)&d_a,sizeof(int)*5);
 cudaMalloc((void **)&d_b,sizeof(int)*5);
 cudaMalloc((void **)&d_c,sizeof(int)*5);
 cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
 cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);
 add<<<1,5>>>(d_a,d_b,d_c);
 cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
 for(int i=0;i<5;i++)
 {
        printf("%d\t",c[i]);
 }
 cudaFree(d_a);
 cudaFree(d_b);
 cudaFree(d_c);
 return 0;
}
