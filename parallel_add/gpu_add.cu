#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void add_arrays_gpu(int *a, int *b, int *c, int N) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < N) {
        c[idx] = a[idx] + b[idx];
    }
}

void generate_random_array(int *array, int N) {
    for (int i = 0; i < N; i++) {
        array[i] = rand() % 100;
    }
}

int main() {
    int N;
    printf("Enter the size of the arrays: ");
    scanf("%d", &N);

    int *a = (int*)malloc(N * sizeof(int));
    int *b = (int*)malloc(N * sizeof(int));
    int *c = (int*)malloc(N * sizeof(int));

    generate_random_array(a, N);
    generate_random_array(b, N);

    int *d_a, *d_b, *d_c;
    cudaMalloc((void**)&d_a, N * sizeof(int));
    cudaMalloc((void**)&d_b, N * sizeof(int));
    cudaMalloc((void**)&d_c, N * sizeof(int));

    cudaMemcpy(d_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (N + blockSize - 1) / blockSize;

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    add_arrays_gpu<<<numBlocks, blockSize>>>(d_a, d_b, d_c, N);
    cudaEventRecord(stop);

    cudaMemcpy(c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    printf("GPU time: %f milliseconds\n", milliseconds);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(a);
    free(b);
    free(c);
    return 0;
}