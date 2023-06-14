input_M = magic(3)

% Convert the matrix to a string representation
input_M_str = mat2str(input_M);
input_M_str = strrep(input_M_str, ' ', ',');
input_M_str = strrep(input_M_str, ';', '],[');
input_M_str = strcat('[',input_M_str,']');

% Call the Python script with the matrix as a command-line argument
command = ['python run_python_from_mat.py "', input_M_str,'"'];
[status, result] = system(command);

% Parse the matrix from the output
masked_matrix = str2num(result)
