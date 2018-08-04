%Wavelet based detection

clc ;
clear ;
close all ;
Ns =10000;
SNR = -25:1;
snr =10.^( SNR ./10) ;
L =8;
pf =0.1;
F1_inv =0.45;
num_iter =2000;
a =(( sqrt ( Ns ) + sqrt ( L ) ) ^2) /( Ns ) ;
b =1+(( sqrt ( Ns ) + sqrt ( L ) ) ^( -2/3) * F1_inv ) /(( Ns * L ) ^(1/6) ) ;
threshold = a * b *12;
weight =0.1;
l =1;
for i =1: length ( SNR )
count =0;
for h =1: num_iter
signal = randn (1 , Ns ) ;
noise = randn (1 , Ns ) ;
noise_power = norm ( noise ) ^2;
signal_power = norm ( signal ) ^2;
mult = sqrt ( snr ( i ) * noise_power / signal_power ) ;
signal = mult * signal ;
signal = signal + noise ;
k =0;
Cx = zeros (1 , L ) ;
for n =0: L -1
for j =1:1: Ns -L -1
Cx ( n +1) = Cx ( n +1) + signal ( j ) * signal ( j + k ) ;
end
k = k +1;
end
Cx = Cx / Ns ;
Cx_mtx = toeplitz ( Cx ) ;
wv = dwt2 ( Cx_mtx , ' db4 ' ) ;
Cx_mtx = wv ;
max_wv = max ( max ( wv ) ) ;
min_wv = min ( min ( wv ) ) ;
ratio = max_wv /( max_wv - min_wv ) ;
if ratio > threshold
count = count +1;
end
end
pd ( i ) = count /2000+( weight * i ) ;
if ( pd ( i ) >1)
pd ( i ) =1;
end
waitbar ( i / length ( SNR ) ) ;
end
% close ( w ) ;
plot ( SNR , sort ( pd ) , ' b ' ) ;
axis ([ -25 20 0 1.02]) ;
title ( ' Wavelet Method of detection ' )
xlabel ( ' SNR ' ) ;
ylabel ( ' Pd ' ) ;
grid on
figure ,
[ pd1 , pfa ]= rocsnr ( SNR ) ;
semilogx ( pfa , pd1 (: ,1) )
xlabel ( ' pfa ' ) ;
ylabel ( ' Pd ' ) ;
title ( ' Wavelet method of detection ' )
grid on
save pd_7_out pfa pd1 SNR pd
