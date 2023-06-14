import numpy as np
import sys
import ast


if __name__ == "__main__":
    input_matrix_str = sys.argv[1]
    # Convert the matrix string back into a numeric array
    input_matrix = np.array(eval(input_matrix_str))
    MASK = np.random.rand(input_matrix.shape[0],input_matrix.shape[1])
    M = MASK*input_matrix
    matrix_str = np.array2string(M, separator=',')
    print(matrix_str)

