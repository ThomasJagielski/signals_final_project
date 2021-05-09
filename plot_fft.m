function [fft_out] = plot_fft(input_signal)
%PLOT_FFT Summary of this function goes here
%   Detailed explanation goes here
    fft_out = fft(input_signal);
    
    figure
    subplot(2,1,1)
    title('Signal in Frequency Domain')
    ylabel('Magnitude')
    xlabel('Frequency [\omega]')
    plot(real(fft_out))
    
    subplot(2,1,2)
    ylabel('Angle')
    xlabel('Frequency [\omega]')
    plot(imag(fft_out))
    
end

