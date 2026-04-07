load ecg.mat   % built-in sample
ecg_signal = ecg;
fs = 360;      % sampling frequency (Hz)
t = (0:length(ecg_signal)-1)/fs;


figure;
plot(t, ecg_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Raw ECG Signal');
grid on;



fc = 0.5; % cutoff frequency
[b,a] = butter(2, fc/(fs/2), 'high');
ecg_hp = filtfilt(b,a,ecg_signal); 

fc = 40;
[b,a] = butter(2, fc/(fs/2), 'low');
ecg_filtered = filtfilt(b,a,ecg_hp);
figure;



plot(t, ecg_signal); hold on;
plot(t, ecg_filtered, 'r');
legend('Raw','Filtered');
title('ECG Signal Filtering');


N = length(ecg_filtered);
f = (-N/2:N/2-1)*(fs/N);
ECG_FFT = fftshift(abs(fft(ecg_filtered)));

figure;
plot(f, ECG_FFT);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('ECG Frequency Spectrum');
[pks, locs] = findpeaks(ecg_filtered, 'MinPeakHeight',0.5, ...
                                     'MinPeakDistance', fs*0.6);

figure;
plot(t, ecg_filtered); hold on;
plot(t(locs), pks, 'ro');
title('R-Peak Detection');





RR_intervals = diff(locs)/fs;   % seconds
HR = 60./RR_intervals;          % bpm

fprintf('Average Heart Rate: %.2f bpm\n', mean(HR));
figure;

subplot(3,1,1);
plot(t, ecg_signal);
title('Raw ECG');

subplot(3,1,2);
plot(t, ecg_filtered);
title('Filtered ECG');

subplot(3,1,3);
plot(t(locs), pks, 'ro');
title('Detected R-peaks');