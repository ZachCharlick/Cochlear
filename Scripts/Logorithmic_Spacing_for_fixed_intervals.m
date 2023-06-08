% Gives bandcenters in Hz
% Gives bandedges in rad/s

number_of_intervals = 4; 

minimum_freq = 250  * 2 * pi;
maximum_freq = 6000 * 2 * pi;

log_min = log10(minimum_freq);
log_max = log10(maximum_freq);

start_of_each_interval = logspace(log_min, log_max, number_of_intervals + 1);

interval_bandcenters = zeros(1,number_of_intervals);
interval_bandwidths = zeros(1,number_of_intervals);

for i = (1:1:number_of_intervals)
   interval_bandwidths(1, i) = start_of_each_interval(1, i + 1) - start_of_each_interval(1, i);
   interval_bandcenters(1, i) = (start_of_each_interval(1, i + 1) - 0.5 * interval_bandwidths(1, i))/(2 * pi);
end