%COSINE

% TotalTime=4*pi;
% dt=0.2;
% t=0:dt:TotalTime-dt;
% y=cos(t);
% figure;
% plot(t,y);
% x=fftshift(fft(y));
% dF=1/TotalTime;
% Fs=1/dt;
% f=-Fs/2:dF:Fs/2-dF;
% figure;
% plot(f,abs(x)/length(y));

clear All

%OURs

[y,Fs]=audioread('SpeechDFT-16-8-mono-5secs.wav');

Fs=Fs*100;

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


%**************************************************************************

% Modulated Signal :
% -----------------

%Time Domain
Fc = 100*10^3;
Wc = 2 * pi * Fc;
Modulation_index=0.9;
Am=abs(min(y));
Ac = Am / Modulation_index;
Mt = Ac+y;
% size(cos(Wc*t)) => 1,39922
%size(transpose(cos(Wc*t)))
MtModu = Mt .* transpose(cos(Wc*t));
subplot(4,2,3)
plot(t,MtModu);

%Frequency Domain
MtModuF=fftshift(fft(MtModu));
subplot(4,2,4)
plot(f,abs(MtModuF)/length(MtModu));

%**************************************************************************

% Noise Added To Signal :
% ---------------------

%Time Domain
SignalNoised = awgn(MtModu,20);
% sound(SignalNoised);
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
[UpperEnvelope,LowerEnvelope]=envelope(SignalNoised);
UpperEnvelope=UperEnvelope-mean(UpperEnvelope);
subplot(4,2,7)
plot(t,UpperEnvelope);

%Frequency Domain
UpperEnvelopeF=fftshift(fft(UpperEnvelope));
subplot(4,2,8)
plot(f,abs(UpperEnvelopeF)/length(UpperEnvelope));
sound(UpperEnvelope);





