%[xAnechoic,fs] = audioread(wavFile); % change this to read in your mp3

% you can use simulink to get the reverb from the xAnechoic
xReverb = [1,2,3,4] % this is where you can put in your reverberant signal for now

xFeatReverb = extractFeaturesAndLabelsSingleFile(xReverb)


function xFeatReverb = extractFeaturesAndLabelsSingleFile(xReverb)
    
    % Feature extraction/mask calculation parameters
    feat_type = 'log_fft_889Hz_preemph';
    fs = 16000; % Hz
    frame_len = 0.008; % s
    %frame_shift = 0.002; % s
    frame_shift = 9/8000; % based on channel stimulation rate from clinical map, seconds
    preemphasis = true;
    
    %
    % OLD Args:
    %   -wavFile (str): .wav file from which to extract features
    %   -feat_type (str): feature type (mfcc or log mel spectrogram)
    %   -mask_type (str): binary, ratio, or fft mask
    %   -ftm_type_mask (str): frequency-time representation to use for mask
    %   calculation (FFT or ACE magnitude spectrum)
    %   -fs (double): sampling frequency in Hz
    %   -frame_len (double): FFT frame length in sec
    %   -frame_shift (double): FFT frame shift in sec
    %   -num_coeffs (int): dimensionality of feature vector at single time step
    %   -preemphasis (bool): whether to apply pre-emphasis filter
    %   -use_energy (bool): whether to use energy as an additional feature
    %   -featFile (str): file containing extracted features and labels
    %   -rir_file (str): name of file that contains the RIR, could be either
    %   a .mat file or a .wav file
    %   -rir_database (str): name of RIR database
    %   -corpus (str): name of speech corpus
    %   -ali_contents (str): contents of the phoneme alignment file
    %
    

    % Apply pre-emphasis, if desired
    if preemphasis
      xReverb = preemphasize(xReverb);

      % Re-normalize
      normFactor = 0.99/max(abs(xReverb));
      xReverb = xReverb*normFactor;
    end
    
    % Extract features
    xFeatReverb = extractFeatures(xReverb, feat_type, fs, frame_len, frame_shift);
    
end

function x = extractFeatures(wav, feat_type, fs, frame_len, frame_shift)
    % Calculate static features for a single wav file
    %
    % Args:
    %   -wav (nx1 array): audio data
    %   -feat_type (str): name of feature
    %   -fs (double): sampling frequency in Hz
    %   -frame_len (double): FFT frame length, sec
    %   -frame_shift (double): FFT frame shift, sec
    %
    % Returns:
    %   -x (nxnFeatures matrix): matrix of features

  % Default ACE map in Nucleus MATLAB Toolbox
  p = ACE_map;

  % Replace default block length and analysis rate with user-defined parameters
  p.block_length = round(frame_len*fs);
  p.analysis_rate = 1/frame_shift;

    % Calculate either mel-frequency cepstral coefficients (mfcc) or log
    % mel spectrogram (mspec)
    switch feat_type
        % ACE power spectrum
        case 'ace'
	    x = calculateAceFeatures(p, wav);

        % log ACE power spectrum
        case 'log_ace'
	    x = calculateAceFeatures(p, wav);
	    x = log(x);
            
        % log FFT power spectrum
        case 'log_fft'
	    x = calculateFftFeatures(p, wav);
	    x = log(x);
            
        otherwise
	    if contains(feat_type, 'log_fft')
	        x = calculateFftFeatures(p, wav);
	        x = log(x);
	    else
              error('Invalid feature type.\n');
	    end
    end
    
end
