%% created on  10-April-2019
%% ALL SIMULATIONS ARE PERFORMED ON MATLAB R2018b  , its observed that on matlab version R2017 lowpass() function is not working.

%% To run the simulation just run the simulator.m 

%%% The codes folders includes 7 files of matlab codes.
%%% simulator.m simulates the whole simulation.
%%% simulator first instantiate 3 iot_class , iot class is defined in iot_class.m 

NOTE: 1. Expected number of binary data at sender side of any IOT dev is multiple of 4.
This is because , we used 16 QAM , so , 4 bits per symbol .
 
2. Aloting frequency to different iot_dev shoud start from 300 Hz ( desired 500 Hz) onwards with a minimum gap of 300 Hz ( desired 500 Hz).
 
%% pulse class is having both square and sinc pulse , using sinc puls is recomended.
%% functions included in iot class are cdma,  pulse mapping and fdma of both I and Q components.

%-------------------------------------AWGN CHANNEL---------------------------------------%
% ------------------------------------receiver-------------------------------------------%

% receiver will first instantiate base_station class , which is defined in baseStation.m 

1. User at base station are supposed to provide two keys
 -----> freq_of_operation_of_iot_dev and its walsh_code , using this user at base station can acess data of desired iot dev.

2. Symbol received after ML estimate is stored is decoded_cdma_data_I and decoded_cdma_data_Q. 

3. The raw binar data is stored in final_data.