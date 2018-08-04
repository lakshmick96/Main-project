%Matched filter detection


clc
clear
close all
SNR = -16:25;
pdd =[];
for i =1: length ( SNR )
antenna = phased . IsotropicAntennaElement ( ' FrequencyRange ' ,[5
e9 15 e9 ]) ;
transmitter = phased . Transmitter ( ' Gain ' ,4 , ' InUseOutputPort ' ,
true ) ;
fc = 10 e9 ;
target = phased . RadarTarget ( ' Model ' , ' Nonfluctuating ' ,...
' MeanRCS ' ,1 , ' OperatingFrequency ' , fc ) ;
txloc = [0;0;0];
tgtloc = [5000;5000;10];
transmitterplatform = phased . Platform ( ' InitialPosition ' , txloc
);
targetplatform = phased . Platform ( ' InitialPosition ' , tgtloc ) ;
[ tgtrng , tgtang ] = rangeangle ( targetplatform . InitialPosition ,
...
transmitterplatform . InitialPosition ) ;
waveform = phased . RectangularWaveform ( ' PulseWidth ' ,25e -6 ,...
' OutputFormat ' , ' Pulses ' , ' PRF ' ,10 e3 , ' NumPulses ' ,1) ;
c = physconst ( ' LightSpeed ' ) ;
maxrange = c /(2* waveform . PRF ) ;
Pt = radareqpow ( c / fc , maxrange , SNR ( i ) ,...
waveform . PulseWidth , ' RCS ' , target . MeanRCS , ' Gain ' ,
transmitter . Gain ) ;
transmitter . PeakPower = Pt ;
radiator = phased . Radiator ( ' PropagationSpeed ' ,c ,...
' OperatingFrequency ' ,fc , ' Sensor ' , antenna ) ;
channel = phased . FreeSpace ( ' PropagationSpeed ' ,c ,...
' OperatingFrequency ' ,fc , ' TwoWayPropagation ' , false ) ;
collector = phased . Collector ( ' PropagationSpeed ' ,c ,...
' OperatingFrequency ' ,fc , ' Sensor ' , antenna ) ;
receiver = phased . ReceiverPreamp ( ' NoiseFigure ' ,0 ,...
' EnableInputPort ' , true , ' SeedSource ' , ' Property ' , ' Seed ' ,2 e3 )
;
filter = phased . MatchedFilter (...
' Coefficients ' , getMatchedFilter ( waveform ) ,...
' GainOutputPort ' , true ) ;
wf = step ( waveform ) ;
[ wf , txstatus ] = step ( transmitter , wf ) ;
wf = step ( radiator , wf , tgtang ) ;
wf = step ( channel , wf , txloc , tgtloc ,[0;0;0] ,[0;0;0]) ;
wf = step ( target , wf ) ;
wf = step ( channel , wf , tgtloc , txloc ,[0;0;0] ,[0;0;0]) ;
wf = step ( collector , wf , tgtang ) ;
rx_puls = step ( receiver , wf ,~ txstatus ) ;
[ mf_puls , mfgain ] = step ( filter , rx_puls ) ;
Gd = length ( filter . Coefficients ) -1;
mf_puls =[ mf_puls ( Gd +1: end ) ; mf_puls (1: Gd ) ];
s = snr ( abs ( mf_puls ) ) ;
[ pd , pfa ]= rocsnr ( abs ( s ) ) ;
pd = sort ( pd ) ;
pdd ( i ) = pd ( end -1) ;
end
pdd = sort ( pdd ) ;
figure ,
plot ( SNR , pdd , ' -b . ' )
xlabel ( ' SNR ' )
ylabel ( ' Pd ' )
title ( ' Matched filter detection ' )
grid on
save pd_2_out pdd SNR
