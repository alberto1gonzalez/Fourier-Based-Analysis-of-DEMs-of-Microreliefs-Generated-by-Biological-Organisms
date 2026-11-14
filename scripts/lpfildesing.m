Fs = 26; %Frecuencia de muestreo, or Sampling rate (number of samples per unit time). %Following Nyquist's Theorem, it is required to be greater than or equal to twice the 
% maximun recorded frequency; use a value in powers of 2
Ts = 1/Fs; % Sampling period (time step)
L = 26; % signal size or number of samples, must be ≥ Fs an in powers of 2.
t = (0:L-1).*Ts; % time vector
dt=0:Ts:2-Ts; % duration of the signal
%A signal composed of three harmonic signals each with a different frequency, and amplitude  has been chosen
% Frequencies
F1 = 1;
F2 = 6;
F3 = 12;
y1 = 10*sin(2*pi*t*F1); % signal of 1Hz frequency and an Amplitude of 10
y2 = 1*sin(2*pi*t*F2); % signal of 60Hz frequency and Amplitude of 6
y3 = 0.5*sin(2*pi*t*F3); % signal of 60Hz frequency and Amplitude of 12
y = (y1)+(y2)+(y3); % composite signal
N = length (y); %Number of samples of the signal= L
N1 = N/20; % Rows, approximately 50 in the example
N2 = 20; % columns
% the size would be 50x20 as in the example
% % % GRAPHICAL REPRESENTATION OF THE INPUT SIGNAL-%
figure(1)
subplot(5,1,1); 
plot (t,y,'k');
title ('Fig. 1, Convolution of frequencies')
xlabel('frequency'),ylabel('Amplitude')
subplot(5,1,2);
plot (t,y1,'r');
title ('fundamental frequency')
xlabel('frequency'),ylabel('Amplitude'),
subplot(5,1,3); 
plot (t,y2,'g');
title ('1st harmonic or component of middle-frequency ')
xlabel('frequency'),ylabel('Amplitude')
subplot(5,1,4); 
plot (t,y3,'b');
title ('2nd harmonic or component  of high frequency ')
xlabel('frequency'),ylabel('Amplitude'),
%%---fiter
d=designfilt('lowpassfir','filterOrder',5,'CutoffFrequency',1,'SampleRate',Fs);
h=filter(d, y);
% h=filtfilt(d, y);
subplot(5,1,5); 
plot (h);hold on; plot(y)