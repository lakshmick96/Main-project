%Comparison between Eigen value & Wavelet detection

figure ,
hold on
load pd_4_out
plot ( SNR , sort ( pd ) , ' -m . ' ) ;
grid on
load pd_7_out
plot ( SNR , sort ( pd ) , ' -b ' ) ;
axis ([ -20 25 0.6 1.02])
grid on
xlabel ( ' SNR ' )
ylabel ( ' pd ' )
title ( ' pd vs SNR ' )
legend ( ' Eigen value detection ' , ' wavelet detection ' )
