#include<stdio.h>
#define K 32 //tile size is KxK
#define N 1024 //matrix size is NxN
__global__ void transpose_serial(int *in, int *out)
{
 for(int i=0;i<N;i++){
 for(int j=0;j<N;j++){
   out[i*N+j]=in[j*N+i];
 }
}
}
__global__ void transpose_per_row(int *in, int *out)
{
 int i=threadIdx.x;
 for(int j=0;j<N;j++){
   out[i*N+j]=in[j*N+i];
 }
}
__global__ void transpose_per_element(int *in, int *out)
{
 int i=blockIdx.x*K+threadIdx.x;
 int j=blockIdx.y*K+threadIdx.y;
 out[i*N+j]=in[j*N+i];
}
__global__ void transpose_per_element_tiled(int *in, int *out)
{
 int in_i=blockIdx.x*K; //Corner point to start reading
 int in_j=blockIdx.y*K;
 int out_i=blockIdx.y*K; //Corner point to start writing
 int out_j=blockIdx.x*K;
 int x=threadIdx.x;
 int y=threadIdx.y;
 __shared__ int tile[K][K];
 tile[y][x] = in[(in_i+x)+(in_j+y)*N];
 __syncthreads();
 out[(out_i+x)+(out_j+y)*N] = tile[x][y];
}
int main(void)
{
 int *in,*out;
 int *d_in,*d_out;
 int size = sizeof(int) * N * N;
in= (int *)(malloc(size));
 out= (int *)(malloc(size));
 //printf("Elements of in \n");
 for(int i=0;i<N;i++)
 {
  for(int j=0;j<N;j++)
  {
    in[i+j*N]=j;
  }
 }
 cudaEvent_t start, stop;
 cudaEventCreate(&start);
 cudaEventCreate(&stop);
 cudaMalloc((void **)&d_in,size);
 cudaMalloc((void **)&d_out,size);
 cudaMemcpy(d_in,in,size,cudaMemcpyHostToDevice);
 dim3 block(N/K,N/K);
 dim3 thread(K,K);
 cudaEventRecord(start);
//transpose_per_element_tiled<<<block,thread>>>(d_in,d_out);
 transpose_per_element_tiled<<<block,thread>>>(d_in,d_out);
//tranpose_per_row<<<1,N>>>
//transpose_serial<<<1,1>>>
 cudaEventRecord(stop);
 cudaEventSynchronize(stop);
 float ms;
 cudaEventElapsedTime(&ms,start,stop);
 cudaMemcpy(out,d_out,size,cudaMemcpyDeviceToHost);
 //printf("Elements of out\n");
// for(int i=0;i<N;i++)
 //{
  //for(int j=0;j<N;j++)
 // {
   // printf("%d\t",out[i+j*N]);
 // }
// }
 printf("Time taken = %f \n",ms);
 cudaFree(d_in);
 cudaFree(d_out);
 return 0;
}
