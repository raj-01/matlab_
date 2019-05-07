% receiver design : class that includes all functions requires by base station 

classdef baseStation 
    properties
        f_samp
        baude_rate
        %filter bank is used to get seprates signals by their frequencies
    end 
    methods 
        function self = baseStation(f_samp , baude_rate)
            self.f_samp = f_samp ;
            self.baude_rate = baude_rate;
        end
        
        function is_my_signal = filter_bank(self ,data ,f_req)
            % band pass filter 
            wpass = [(2*f_req -200) , (2*f_req+200)]/(4*self.f_samp); % samp freq = 4 times
            is_my_signal = bandpass(data,wpass);
        end 
        function down_samp_data = down_sampling_I(self ,data, f_req )
            %first multipy with cos and than low pass filter( require %%f_samp)
            t= 0:1/(4*self.f_samp):(length(data)/(4*self.f_samp)-1/(4*self.f_samp)); 
            %data_ = data.*(4.*((cos((2*pi*f_req).*t))));
            data_ = (data).*(2.*cos(2*pi*f_req.*t)) ; 
            down_samp_data = lowpass(data_,(100)/(4*(self.f_samp)));
            
        end
        function down_samp_data = down_sampling_Q(self ,data, f_req )
            %first multipy with sin and than low pass filter( require %%f_samp)
            t= 0:1/(4*self.f_samp):(length(data)/(4*self.f_samp)-1/(4*self.f_samp)); 
            %data_ = data.*(4.*((cos((2*pi*f_req).*t))));
            data_ = (data).*(2.*sin(2*pi*f_req.*t)) ; 
            down_samp_data = lowpass(data_,(100)/(4*(self.f_samp)));
            
        end
        function avg_val = cal_avg_val( self,down_samp_data)
            % pulse widh is defined by bude rate 
            % bade rate and sampling frequency together both decides num of
            % elements in array we have to consider
            width_of_pulse = floor((4*self.f_samp)/self.baude_rate);
            temp_sum = 0 ; 
            avg_val = [];
            for i=1:width_of_pulse:(length(down_samp_data)-width_of_pulse)
                for j=i:(i+width_of_pulse-1)
                    temp_sum = temp_sum + down_samp_data(j) ;
                end 
                temp_sum = temp_sum/width_of_pulse;
                avg_val = [avg_val , temp_sum] ;
            end 
        end 
        function [data_after_ml_I,data_after_ml_Q]= ml_rule(self , avg_data_val_I , avg_data_val_Q)
                % decision rule for the received data 
                % delta_ml(y) = arg min || y - Si||^2 
                %                 0<=i<=M-1   
                S = [ 1 -1 3 -3] ;
                data_after_ml_I = [] ;
                data_after_ml_Q = [] ;
                for i=1:length(avg_data_val_I)
                    [val , idx ] = min( abs( avg_data_val_I(i) - S));
                    data_after_ml_I = [data_after_ml_I,S(idx)];
                end 
                for i=1:length(avg_data_val_Q)
                    [val , idx ] = min( abs( avg_data_val_Q(i) - S));
                    data_after_ml_Q = [data_after_ml_Q,S(idx)];
                end 
        end 
        function data_ = sym_to_data_bits(self,data_after_ml_I,data_after_ml_Q)
                    data_ = [];
                    match_sym = find_class() ;
                    for i=1:length(data_after_ml_I)
                        data_ = [data_,match_sym.sym_to_bits(data_after_ml_I(i) ,data_after_ml_Q(i))];
                    end   
        end 
        function decoded_cdma_data = cdma_decoder( self,data , cdma_signature )
            decoded_cdma_data = [];    
            for i = 1:length(cdma_signature):length(data)
                    decoded_cdma_data = [ decoded_cdma_data ,(sum(cdma_signature.*data(i:(i+length(cdma_signature)-1))))/length(cdma_signature)];
            end      
        end
                    
    end 
end 
            