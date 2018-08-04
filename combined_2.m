%Modified adaptive spectrum sensing

clc
close all
clear all
figure ,
load pd_2_out pdd SNR
plot ( SNR , pdd )
xlabel ( ' SNR ' )
ylabel ( ' Pd ' )
title ( ' Matched filter detection ' )
grid on
figure ,
load pd_6_out
snr =0:41;
plot ( snr , Pd , ' -r . ' )
hold on
load pd_7_out
plot ( SNR , sort ( pd ) , ' -b ' ) ;
axis ([ -25 20 0 1.02])
grid on
xlabel ( ' SNR ' )
ylabel ( ' pd ' )
title ( ' pd vs SNR ' )
legend ( ' Energy detection ' , ' Wavelet detection ' )
