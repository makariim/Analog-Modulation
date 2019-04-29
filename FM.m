
clear All

[y,FsOriginal]=audioread('SpeechDFT-16-8-mono-5secs.wav');

Fs=FsOriginal*100;

audiowrite('MyAudio.wav',y,Fs);

[y,Fs]=audioread('MyAudio.wav');

% sound(y);

% *************************************************************************

% Initialization :
% -----------------

% Create a figure
figure;

% Time Domain Axes
dt = 1/Fs;
TotalTime=length(y)*dt;
t=0:dt:TotalTime-dt;

% Frequency Domain Axes
dF=1/TotalTime;
f=-Fs/2:dF:Fs/2-dF;


% *************************************************************************

% Original Signal :
% -----------------

%Time Domain

subplot(4,2,1)
plot(t,y);

%Frequency Domain
x=fftshift(fft(y));
subplot(4,2,2)
plot(f,abs(x)/length(y));

% *************************************************************************

% Calculating Variables :
% ---------------------

% st=Ac cos(2*pi*Fc*t+Kf*at)

Fc = 100*10^3;
Wc = 2 * pi * Fc;
Beta=5;
Fm = FsOriginal/2;
DeltaF = Beta * Fm;
Am = max(abs(y));
Kf = (2 * pi * DeltaF) / Am;
at = cumsum(y).*(1/Fs);

%**************************************************************************

% Modulated Signal :
% -----------------

%Time Domain
st=1000.*cos(Wc.*t+Kf.*transpose(at));
subplot(4,2,3)
plot(t,st);

% Frequency Domain
sw=fftshift(fft(st));
subplot(4,2,4)
plot(f,abs(sw)/length(st));

% sound(st);
    
%**************************************************************************

% Noise Added To Signal :
% ---------------------

%Time Domain
SignalNoised = awgn(st,20);
subplot(4,2,5)
plot(t,SignalNoised);

%Frequency Domain
SignalNoisedF=fftshift(fft(SignalNoised));
subplot(4,2,6)
plot(f,abs(SignalNoisedF)/length(SignalNoised));

%**************************************************************************

% Demodulated Signal :
% ---------------------

%Time Domain
Demod=fmdemod(SignalNoised,Fc,Fs,DeltaF);
subplot(4,2,7)
plot(t,Demod);

%Frequency Domain
DemodF=fftshift(fft(Demod));
subplot(4,2,8)
plot(f,abs(DemodF)/length(Demod));
sound(Demod);

