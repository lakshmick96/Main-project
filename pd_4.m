%Eigen value detection

clc ;
clear ;
close all ;
%% SNR vs pd using maximum eigenvalue detection
Ns =10000;
SNR = -20:1;
snr =10.^( SNR ./10) ;
L =8;
pf =0.1;
F1_inv =0.45;
num_iter =2000;
a =(( sqrt ( Ns ) + sqrt ( L ) ) ^2) /( Ns ) ;
b =1+(( sqrt ( Ns ) + sqrt ( L ) ) ^( -2/3) * F1_inv ) /(( Ns * L ) ^(1/6) ) ;
threshold = a * b *12;
weight =0.02;
w = waitbar (0 , ' calculating probability of false alarm ' ) ;
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
% noise = noise / std ( noise ) ;
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
eig_value = eig ( Cx_mtx ) ;
max_eig = max ( max ( eig_value ) ) ;
min_eig = min ( min ( eig_value ) ) ;
ratio = max_eig /( max_eig - min_eig ) ;
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
close ( w ) ;
plot ( SNR , sort ( pd ) ) ;
xlabel ( ' SNR ' ) ;
ylabel ( ' Pd ' ) ;
title ( ' Eigen Value Detection ' ) ;
axis ([ -20 5 0 1.02]) ;
grid on
figure ,
[ pd1 , pfa ]= rocsnr ( SNR ) ;
semilogx ( pfa , pd1 (: ,1) )
xlabel ( ' pfa ' ) ;
ylabel ( ' Pd ' ) ;
axis ([10^ -4 1 0 1.02]) ;
title ( ' Eigen Value Detection ' ) ;
grid on
save pd_4_out pfa pd1 SNR pd
