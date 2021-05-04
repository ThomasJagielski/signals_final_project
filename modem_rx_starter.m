
load short_modem_rx.mat

% The received signal includes a bunch of samples from before the
% transmission started so we need discard the samples from before
% the transmission started. 

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = y_r(start_idx+length(x_sync):end); % y_t is the signal which starts at the beginning of the transmission


%  Put your decoder code here
% create a cosine with analog frequency f_c
c = cos(2*pi*f_c/Fs*[0:length(y_t)-1]');
% create the transmitted signal
y_rx = y_t.*c;
%plot(y_rx)  % visualize the transmitted signal

% Low Pass Filter
W = 2*pi*1;
%t = [-(length(y_t)/2):1:((length(y_t)/2)-1)]*(1/Fs);
t = [-10:1:10]*(1/Fs);
h = W/pi*sinc(W/pi*t);

x_d = conv(y_rx, h);
plot(x_d(1:5000))



%%
x_d(1) = 0;
for l=2:length(x_d)
    if (x_d(l) > 0.5)
        x_d(l) = 1;
    elseif (x_d(l) < 0.5)
        x_d(l) = 0;
    else
        x_d(l) = x_d(l-1);
    end
end

plot(x_d(1:5000))

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
BitsToString(x_d(1:5004))

