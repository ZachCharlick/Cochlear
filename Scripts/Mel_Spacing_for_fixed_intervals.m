number_of_intervals = 20; 

start = 250;
stop = 6000;

start_of_each_interval = zeros(1, number_of_intervals + 1);
start_of_each_interval(1) = start;

interval_bandcenters = zeros(1,number_of_intervals);
interval_bandwidths = zeros(1,number_of_intervals);

mstart = mel(start);

ydif = (mel(stop) - mstart)/number_of_intervals;

bandedges = [];

for i = (1:1:number_of_intervals)
    start_of_each_interval(i+1) = reversemel(mstart+i*ydif);
end

for i = (1:1:number_of_intervals)
   interval_bandwidths(1, i) = start_of_each_interval(1, i + 1) - start_of_each_interval(1, i);
   interval_bandcenters(1, i) = (start_of_each_interval(1, i + 1) - 0.5 * interval_bandwidths(1, i)); % in hz
end

for i = (1:1:number_of_intervals + 1)
   start_of_each_interval(1, i) = start_of_each_interval(1, i) * 2 * pi;
end

function m = mel(f)
    m = 1000*log10(f/800 + 1);
end

function f = reversemel(m)
    f = (10^(m/1000)-1)*800;
end