%% FUNCTIONS
function [X, f] = plot_ft_rad(x, fs)
    % plots the magnitude of the Fourier transform of the signal x
    % which is assumed to originate from a Continous-time signal 
    % sampled with frequency fs
    % the function returns X and f.
    % In other words, this function plots the FT of the DT signal x
    % with the frequency axis labeled as if it were the original CT signal
    % 
    % X contains the frequency response
    % f contains the frequency samples


    N = length(x);

    X = fftshift(fft(x));
    
    % note that the frequency range here is from -fs/2*2*pi -> something
    % just a little bit less of fs/2*2*pi
    % this is an artefact of the fact that we are actually computing a 
    % Discrete-Fourier-Transform (DFT) when we call FFT (which is a
    % numerical method to efficiently compute the DFT).
    
    f = linspace(-fs/2*2*pi, 2*pi*fs/2- 2*pi*fs/length(x), length(x));
    plot(f, abs(X));
    xlabel('Frequency (rad/s)');
    ylabel('|X(j\omega)|');
end