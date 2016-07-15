#include<stdio.h>
__global__ void kernel(int * a, int * b)
{
 *b=*a+*b;
}
int main(void)
{
int h_in,h_out;
int *d_out,*d_in;
h_in=2;
h_out=7;
cudaMalloc((void **)&d_out,sizeof(int));
cudaMalloc((void **)&d_in,sizeof(int));
cudaMemcpy(d_in,&h_in,sizeof(int),cudaMemcpyHostToDevice);
cudaMemcpy(d_out,&h_out,sizeof(int),cudaMemcpyHostToDevice);
kernel<<<1,1>>>(d_in,d_out);
cudaMemcpy(&h_out,d_out,sizeof(int),cudaMemcpyDeviceToHost);
printf("%d\n",h_out);
cudaFree(d_in);
cudaFree(d_out);
return 0;
}
