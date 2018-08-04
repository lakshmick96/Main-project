% Energy detection

clc
close all
clear all
L = 1000;
snr_dB = -25:16; % SNR in decibels
snr = 10.^( snr_dB ./10) ; % Linear Value of SNR
Pf = 0.1;
for m = 1: length ( snr )
m
i = 0;
for kk =1:10000 % Number of Monte Carlo Simulations
n = randn (1 , L ) ; % AWGN noise with mean 0 and variance 1
s = sqrt ( snr ( m ) ) .* randn (1 , L ) ; % Real valued Gaussina Primary
User Signal
y = s + n ; % Received signal at SU
energy = abs ( y ) .^2; % Energy of received signal over N
samples
energy_fin =(1/ L ) .* sum ( energy ) ;
thresh ( m ) = ( qfuncinv ( Pf ) ./ sqrt ( L ) ) + 1;
if ( energy_fin >= thresh ( m ) )
i = i +1;
end
end
Pd ( m ) = i / kk ;
end
plot ( snr_dB +20 , Pd , ' -r . ' )
axis ([ -5 25 0 1.02])
xlabel ( ' SNR ' )
ylabel ( ' Pd ' )
title ( ' Energy Detection method ' )
grid on
save pd_6_out snr Pd
