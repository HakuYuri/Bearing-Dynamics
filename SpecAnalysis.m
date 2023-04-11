% Initial parameters
StartTime = 0;
EndTime = StartTime + 10;
Channel = 7;
% Sampling Frequency
FreqSam = 20e3;

% Load metadata
Data = readmatrix('CKCE-M1-HS1500-DJNQGZ-YZ-20KHZ.csv');


StartNum = StartTime * FreqSam;
EndNum = EndTime * FreqSam;

Time = StartTime : 1 / 20e3 : EndTime;
Num = StartNum : EndNum;


MetaSig = Data(StartNum + 1 : EndNum + 1, Channel + 1);
N = length(MetaSig);


% Get envelope spectrum
[EnvCurve, EnvelopeSpectrum, EnvFreqAxis, EnvAlterData] = EnvSpec(MetaSig, FreqSam);

% Get frequency spectrum

[FFTSpec, FFTFreqAxis, FFTAlterData] = myFFT(MetaSig, FreqSam);

% % Draw envelope curve
% figure(12);
% subplot(1,2,1);
% plot(AlterData);
% hold on;
% plot(Env, 'r');
% legend('Signal', 'Envelope');
% xlabel('Sample');
% ylabel('Amplitude');
% title('Signal Envelope');

figure(12);
% subplot(1,2,2);
plot(EnvFreqAxis(1:N/2), EnvelopeSpectrum(1:N/2));
xlabel('Frequency (Hz)');
ylabel('Amptitude');
title('Envelope Spectrum');
axis([0 500 0 1.2 * max(EnvelopeSpectrum(1:N/2))]);


figure(13);
plot(FFTFreqAxis(1:N/2), FFTSpec(1:N/2));
xlabel('Frequency (Hz)');
ylabel('Amptitude');
title('FFT Spectrum');
axis([0 500 0 1.2 * max(FFTSpec(1:N/2))]);
