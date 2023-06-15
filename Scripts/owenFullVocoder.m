[input,fs] = audioread('CUNY0101.wav');

shape = size(input);

len = shape(1);

 

% sound(input,fs); %play original
% pause(2.5);

 

[output,rmss] = fixedchannel(input,4,fs,len);

% soundsc(output,fs); %play vocoder original
% pause(2.5);

 

airpar.fs = 48e3;

airpar.rir_type = 1;

airpar.room = 4;

airpar.channel = 1;

airpar.head = 1;

airpar.rir_no = 5;

[noise,noise_info] = load_air(airpar);
r = noise_info.fs/fs;
noise = noise(:,1:r:end);
noise = noise.';
noise = 100000*noise;

timestamps = 0:fs:(length(noise)*fs - 1);
timestamps = timestamps.';
disp(length(timestamps));

noisyMatrix = [timestamps, noise];

noisyinput = addnoise(input,airpar,len,fs);

soundsc(noisyinput,fs)
pause(2.5);

[noisyoutput,rmss] = fixedchannel(noisyinput,4,fs,len);

% soundsc(noisyoutput,fs); %play vocoder
% pause(2.5);

 

%------PLOT RMS-------

% for n = 1:20  

%     figure(n);

%     plot(rmss(n,:));

% end

%------PLOT SPECTRUM-------

% nf=1024; %number of point in DTFT

% Y = fft(output,nf);

% f = fs/2*linspace(0,1,nf/2+1);

% plot(f,abs(Y(1:nf/2+1)));

%------SAVE AS WAV FILE-------

% audiowrite("vocoder.wav",output,fs);

 

function [noisyinput] = addnoise(input,airpar,length,Fs)

    input = input;

    [noise,noise_info] = load_air(airpar);

    % noise = noise(:,1:30000); %quiet after 30000

    % r = noise_info.fs/Fs;
    % 
    % noise = noise(:,1:r:end);
    % 
    % l = size(noise);
    % 
    % while l(2) < length
    % 
    %     noise = [noise,noise];
    % 
    %     l = size(noise);
    % 
    % end
    % 
    % noise = noise(:,1:length);

    noisyinput = conv(input, noise); %multiplied by 10 so you can hear it

end

 

function [output,rmss] = fixedchannel(input,N,fs,length)

    duration = length/fs;

    bandedges = findedges(N)

    

    ybands = splitbands(input,bandedges,N,fs);

    output = zeros(1,length);

    rmss = [];

    for n = 1:N

        yband = ybands(:,n);

        freq = (bandedges(n)+bandedges(n+1))/2;

        sinusoid = makenote(freq,duration,fs);

        rms = getrms(yband,fs).';

        rmss = [rmss;rms];

        o = rms.*sinusoid;

        output = output + o;

    end

end

 

function [rms] = getrms(yband,fs)

    y = abs(yband); %rectifying it makes it sound bad

    [b,a] = butter(2,400/(fs/2));

    z = filter(b,a,y); %this filter also makes it sound bad

    windowsize = round(4/(1000/fs)); %rms computed every 4ms = windowsize samples

    [yupper,ylower] = envelope(yband,windowsize,'rms'); %changed to yband here

    %envelope(z,windowsize,'rms');

    rms = yupper;

end

 

function [ybands] = splitbands(x,bandedges,N,fs)

    ybands = [];

    for n = 1:N

        flow = bandedges(n);

        fhigh = bandedges(n+1);

        [b,a] = butter(3,[flow,fhigh]/(fs/2), 'bandpass'); %order: 6/2=3

        y = filter(b,a,x);

        ybands = [ybands,y];

    end

end

 

function [vector_note] = makenote(freq,dur,fs)

    t = [0:1/fs:(dur-1/fs)]; % t array

    vector_note = sin(2*pi*(freq)*(t));

end

 

function [bandedges] = findedges(N);

    if N <= 6

        bandedges = logspacing(N);

    else

        bandedges = melspacing(N);

    end

end

 

function [bandedges] = logspacing(N)

    start = 250;

    stop = 6000;

    expdif = (log10(stop)-log10(start))/(N);

    bandedges = [];

    for a = 0:N

        bandedges(a+1) = start*10^(a*expdif);

    end

end

 

function [bandedges] = melspacing(N)

    start = 250;

    stop = 6000;

    mstart = mel(start);

    ydif = (mel(stop) - mstart)/N;

    bandedges = [];

    for a = 0:N

        bandedges(a+1) = reversemel(mstart+a*ydif);

    end

end

 

function m = mel(f)

    m = 1000*log10(f/800 + 1);

end

 

function f = reversemel(m)

    f = (10^(m/1000)-1)*800;

end