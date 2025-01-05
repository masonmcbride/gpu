#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Function to add two arrays
void add_arrays_cpu(int *a, int *b, int *c, int N) {
    for (int i = 0; i < N; i++) {
        c[i] = a[i] + b[i];
    }
}

// Function to generate random array
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

    clock_t start = clock();
    add_arrays_cpu(a, b, c, N);
    clock_t end = clock();

    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("CPU time: %f seconds\n", cpu_time_used);

    free(a);
    free(b);
    free(c);
    return 0;
}
