
load short_modem_rx.mat
%load long_modem_rx.mat

SymbolPeriod = 100;
% The received signal includes a bunch of samples from before the
% transmission started so we need discard the samples from before
% the transmission started. 

figure
subplot(2,1,1)
plot(y_r)  % visualize the transmitted signal
title('Received Signal Raw')
ylabel('Signal Magnitude')
xlabel('Samples [n]')
subplot(2,1,2)
plot_ft_rad(y_r, Fs);

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = y_r(start_idx+length(x_sync):end); % y_t is the signal which starts at the beginning of the transmission

figure
subplot(2,1,1)
plot(y_t)  % visualize the transmitted signal
title('Received Signal Trimmed')
ylabel('Signal Magnitude')
xlabel('Samples [n]')
subplot(2,1,2)
plot_ft_rad(y_t, Fs);

%  Put your decoder code here
% create a cosine with analog frequency f_c
c = cos(2*pi*f_c/Fs*[0:length(y_t)-1]');
% create the transmitted signal
y_rx = y_t.*c;

figure
subplot(2,1,1)
plot(y_rx)  % visualize the transmitted signal
title('Received Signal Multiplied by Cosine Wave')
ylabel('Signal Magnitude')
xlabel('Samples [n]')
subplot(2,1,2)
plot_ft_rad(y_rx, Fs);

% Low Pass Filter
W = 200;
%t = [-(length(y_t)/2):1:((length(y_t)/2)-1)]*(1/Fs);
t = [-10:1:10]*(1/Fs);
h = W/pi*sinc(W/pi*t);

x_d = conv(y_rx, h);

figure
subplot(2,1,1)
plot(x_d(1:5000))  % visualize the transmitted signal
title('Signal after Sinc LPF')
ylabel('Signal Magnitude')
xlabel('Samples [n]')
subplot(2,1,2)
plot_ft_rad(x_d, Fs);

x_d = double(x_d > 0);

for k=1:length(x_d)
    if (k >= ((msg_length*SymbolPeriod*8)+0.75*SymbolPeriod))
        x_d(k) = 0;
    end
end

figure
subplot(2,1,1)
plot(x_d(1:5000))  % visualize the transmitted signal
title('Signal with Binary Processing')
ylabel('Signal Magnitude')
xlabel('Samples [n]')
subplot(2,1,2)
plot_ft_rad(x_d, Fs);

test = x_d;

indc = find(diff(test>0))
gaps = round(diff(indc)/SymbolPeriod)
main = []
sign = 0
for g=1:length(gaps)
    g
    main
    if sign == 0
        main = [main, zeros(1,uint32(gaps(g)),'uint32')];
        sign = 1;
    else
        main = [main, ones(1,gaps(g))] ;
        sign = 0;
    end

end

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
%message = main(1:SymbolPeriod:(msg_length*SymbolPeriod*8)+0.75*SymbolPeriod);
%a = message(1:msg_length*8);
main = double(main);
BitsToString(main(1:msg_length*8))