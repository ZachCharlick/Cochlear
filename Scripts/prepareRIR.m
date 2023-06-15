
% ---------------------------------------------------------------%
% SET UP AND LOAD THE AIRPAR RIR
airpar.fs = 48e3;
airpar.rir_type = 1;
airpar.room = 4;
airpar.channel = 1;
airpar.head = 1;
airpar.rir_no = 5;

[noise,noise_info] = load_air(airpar);
% ---------------------------------------------------------------%

% ---------------------------------------------------------------%
% REDUCE SAMPLEING RATE/AMPLIFY, COMBINE w/ TIME FOR SIMULINK
r = noise_info.fs/fs;
noise = noise(:,1:r:end);
noise = noise.';
noise = 100000*noise;

timestamps = 0:fs:(length(noise)*fs - 1);
timestamps = timestamps.';

noisyMatrix = [timestamps, noise];
% ---------------------------------------------------------------%