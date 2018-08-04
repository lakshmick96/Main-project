%Adaptive spectrum sensing

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
axis ([ -20 25 0 1.02])
hold on
load pd_4_out
plot ( SNR , sort ( pd ) , ' -b . ' ) ;
grid on
xlabel ( ' SNR ' )
ylabel ( ' Pd ' )
title ( ' pd vs SNR ' )
legend ( ' Energy detection ' , ' Eigen value detection ' )
