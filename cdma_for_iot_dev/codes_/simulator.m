%% simulator 
%%%%%%%%%%%%%%%%%%%%%% transmiter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% limit of input frequency( freq )  to fdma is 300 last and the max is bounded by f_sampling 
% using 16 QAM ; bs = { +-1 , +-3} and bc = { +-1 , +-3} bc + bsj, so 4bits per symbol
%[(+1,+1) --> 0000] ; [(+1,-1) --> 0001] ; [(+1,+3) --> 0010]; [(+1,-3) --> 0011]
%[(-1,+1) --> 0100] ; [(-1,-1) --> 0101] ; [(-1,+3) --> 0110]; [(-1,-3) --> 0111]
%[(+3,+1) --> 1000] ; [(+3,-1) --> 1001] ; [(+3,+3) --> 1010]; [(+3,-3) --> 1011]
%[(-3,+1) --> 1100] ; [(-3,-1) --> 1101] ; [(-3,+3) --> 1110]; [(-3,-3) --> 1111]
clear ; 
% please give data in multiples of 4 
bin_data_to_send1 = [0 0 1 1 0 1 0 1 1 1 0 0 1 1 1 1 0 1 1 0]; % I = [1 -1 -3 -3 -1] ,Q=[-3 -1 1 -3 3]
bin_data_to_send2 = [1 0 0 1 0 1 0 1 1 1 0 0 1 0 1 1 0 0 1 0]; % I = [3 -1  -3  3 1] , Q = [-1 -1 1 -3 3]
bin_data_to_send3 = [0 1 0 0 1 1 1 1 0 1 1 1 1 0 0 1 1 0 0 0]; % I = [-1 -3 -1 3 3] , Q = [1 -3 -3 -1 1]
walsh_code1 = [1 -1 1 -1 1 -1 1 -1 ];
walsh_code2 = [1 1 -1 -1 1 1 -1 -1];
walsh_code3 = [1 -1 -1 1 1 -1 -1 1];
f_sampling = 10000 ; % actualy I used 4*f_sampling  = 40000 is samling rate 
baude_rate = 100;   % samples per secound 
% instantiating iot_class(data_to_send,walsh_code,f_samp,freq,baude_rate)
% freq is expected to be greater than 500 Hz and min gap between two aloted
% frequency shoub be 300 Hz 
iot_dev_1 = iot_class(walsh_code1,f_sampling ,500,baude_rate); % iot dev 1 is at 500 Hz
iot_dev_2 = iot_class(walsh_code2,f_sampling,1000,baude_rate);  % iot dev 2 is at 1000 Hz 
iot_dev_3 = iot_class(walsh_code3,f_sampling,1500,baude_rate);  % iot dev 3 is at 1500 Hz
% maping bits to symbol 
[I_1 , Q_1] = iot_dev_1.bits_to_sym(bin_data_to_send1); 
[I_2 , Q_2] = iot_dev_2.bits_to_sym(bin_data_to_send2); 
[I_3 , Q_3] = iot_dev_3.bits_to_sym(bin_data_to_send3);
% symbolt to cdma conversion
cdma_data_I1 = iot_dev_1.cdma(I_1);
cdma_data_Q1 = iot_dev_1.cdma(Q_1);
cdma_data_I2 = iot_dev_2.cdma(I_2);
cdma_data_Q2 = iot_dev_2.cdma(Q_2);
cdma_data_I3 = iot_dev_3.cdma(I_3);
cdma_data_Q3 = iot_dev_3.cdma(Q_3);
% symbol to pulse u(t) = sigma(bn*p(t-nT)) 
bits_to_pulse_I1 = iot_dev_1.bits_to_pulse(cdma_data_I1);
bits_to_pulse_Q1 = iot_dev_1.bits_to_pulse(cdma_data_Q1);
bits_to_pulse_I2 = iot_dev_2.bits_to_pulse(cdma_data_I2);
bits_to_pulse_Q2 = iot_dev_2.bits_to_pulse(cdma_data_Q2);
bits_to_pulse_I3 = iot_dev_3.bits_to_pulse(cdma_data_I3);
bits_to_pulse_Q3 = iot_dev_3.bits_to_pulse(cdma_data_Q3);
% In fdma I componet to cos and Q component to sin 
fdma_data_I1 = iot_dev_1.fdma_I(bits_to_pulse_I1);
fdma_data_Q1 = iot_dev_1.fdma_Q(bits_to_pulse_Q1);
fdma_data_I2 = iot_dev_2.fdma_I(bits_to_pulse_I2);
fdma_data_Q2 = iot_dev_2.fdma_Q(bits_to_pulse_Q2);
fdma_data_I3 = iot_dev_3.fdma_I(bits_to_pulse_I3);
fdma_data_Q3 = iot_dev_3.fdma_Q(bits_to_pulse_Q3);
data_sent = fdma_data_I1 + fdma_data_Q1 + fdma_data_I2 + fdma_data_Q2 + fdma_data_I3 + fdma_data_Q3;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%AWGN channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_received = awgn(data_sent ,5);   % awgn(data , snr ) , snr in db 
%%%%%%%%%%%%%%%%%%%%%% receiver %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
base_station = baseStation(f_sampling , baude_rate) ;    % f_samp and baude rate of sender and receiver shoud same

%changing this two key of frequncy required and walsh_code one can acces desird iot device data 
freq_to_filter_out = 1000 ;   %% chosing a frequency which receiver wants to filter out 
walsh_code = walsh_code2;    %% walsh code to filter out 

%filters all frequency except --> freq_to_filter_out  
freq_data = base_station.filter_bank( data_received,freq_to_filter_out );

% the high pass data of fdma is down converted to baseband
down_samp_data_I = base_station.down_sampling_I(freq_data,freq_to_filter_out);
down_samp_data_Q = base_station.down_sampling_Q(freq_data,freq_to_filter_out);

% calculating avg/estimate value by summing over the pulse width
avg_data_val_I = base_station.cal_avg_val(down_samp_data_I);
avg_data_val_Q = base_station.cal_avg_val(down_samp_data_Q);

% using ML rule to detrimine symbol received 
[data_after_ml_I,data_after_ml_Q]= base_station.ml_rule(avg_data_val_I,avg_data_val_Q);

%checking for cdma decoded sym data 
decoded_cdma_data_I = base_station.cdma_decoder( data_after_ml_I, walsh_code);
decoded_cdma_data_Q = base_station.cdma_decoder( data_after_ml_Q , walsh_code);

% searching through the find class / look_up table and maping symbol to bits 
final_data = base_station.sym_to_data_bits(decoded_cdma_data_I,decoded_cdma_data_Q);

%% plots of sender 
figure(1);
subplot(3,2,1);
plot( bits_to_pulse_I1  , 'r');
title('Bits to pulse mapping of CDMA data for iot dev 1');
hold on ;
plot(bits_to_pulse_Q1 , 'b');
legend('I component ' , ' Q component ');
subplot(3,2,2);
plot( fdma_data_I1  , 'r');
title('fdma data for iot dev 1');
hold on ;
plot(fdma_data_Q1 , 'b');
legend('I component ' , ' Q component ');
subplot(3,2,3:4);
plot(data_sent);
title('Data sent by IOT dev 1 and 2 both in I and Q');
subplot(3,2,5:6);
plot(data_received);
title('Data receved at receiver = data sent + AWGN');

% plots of receiver side
figure(2);
subplot(3,2,1:2);
plot(freq_data);
title(' Received passband signal for iot dev at ' + string(freq_to_filter_out ) + ' Hz');
subplot(3,2,3);
plot(down_samp_data_I);
title('I component of downsample data for iot dev at ' + string(freq_to_filter_out ) + ' Hz');
subplot(3,2,4);
plot(down_samp_data_Q);
title('Q component of downsample data for iot dev at ' + string(freq_to_filter_out ) + ' Hz');
subplot(3,2,5);
plot(avg_data_val_I);
title('avg data value of I component for iot dev at ' + string(freq_to_filter_out ) + ' Hz');
subplot(3,2,6);
plot(avg_data_val_Q);
title('avg data value of Q component for iot dev at ' + string(freq_to_filter_out ) + ' Hz');

% snr_vs_error(bin_data_to_sent1 ,data_sent,freq_to_filter_out,walsh_code,f_sampling, baude_rate ,I,Q)
figure(3);
snr_vs_error(bin_data_to_send1,data_sent,freq_to_filter_out,walsh_code, f_sampling,baude_rate,I_1 ,Q_1);

%% power conumption 
%figure(4)
%power_consumption(fdma_data_I1 + fdma_data_Q1 , fdma_data_I2 + fdma_data_Q2 , fdma_data_I3 + fdma_data_Q3);


