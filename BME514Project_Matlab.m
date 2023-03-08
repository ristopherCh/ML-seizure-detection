clc
clear

T = readtable('df2.csv');

fs = 173.61; %Hz
w = height(T);

%%

timestep = linspace(0,1000,178);

EEG = T{14,2:end};

plot(timestep, EEG)
title('Normal EEG time series')
xlabel('Time (ms)')
ylabel('EEG')
ylim([-500 500])

%% periodogram and wave bands

for q = (1:w)
  A = T{q,2:end};
  A = A - mean(A);
  A = [A zeros(1,178)];
  N = length(A);
  Ny = fs/2;
  d = Ny/N;
  

  [pxx,f] = periodogram(A,[],N,fs);
  
  total = sum(pxx);
  %total = 1;
  delta = sum(pxx(round(0.5/d):round(4/d)))/total; %0.5-4 Hz
  theta = sum(pxx(round(4/d):round(8/d)))/total; %4-8Hz
  alpha = sum(pxx(round(8/d):round(12/d)))/total; %8-12Hz
  beta = sum(pxx(round(12/d):round(35/d)))/total; %12-35Hz
  gamma = sum(pxx(round(35/d):end))/total; %35- Hz
  
  matrix(q,1) = delta;
  matrix(q,2) = theta;
  matrix(q,3) = alpha;
  matrix(q,4) = beta;
  matrix(q,5) = gamma;
end

%%

A2 = T{20,2:end};
A2 = A2 - mean(A2);
A2 = [A2 zeros(1,178)];
N2 = length(A2);
Ny2 = fs/2;
d2 = Ny2/N2;

[pxx2,f2] = periodogram(A2,[],N2,fs);
plot(f2, pxx2)
title('Periodogram - Seizure')
xlabel('Frequency, Hz')
ylabel('PSD, Units^2/Hz')
xlim([0 40])

%% mean and variance

for q = (1:w)
    A = T{q,2:end};
    A = A - mean(A);
    matrix(q,6) = median(A);
    matrix(q,7) = std(A);
end

%% sample entropy

m = 2;
r = 0.15;


for q = (1:w)
    A = T{q,2:end};
    matrix(q,8) = sampen(A, m, r);
end

%%
writematrix(matrix, 'matrix2.csv')