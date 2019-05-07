%% plot snr graph 
function snr_vs_error(bin_data_to_send,data_sent,freq_to_filter_out,walsh_code,f_sampling, baude_rate ,I,Q)
        total_sym_error = [];
        total_bit_error = [] ;
        snr = [];
        for j=3:0.8:30
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%AWGN channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            data_received = awgn(data_sent ,-j);
            snr =[ snr , -j];
            %%%%%%%%%%%%%%%%%%%%%% receiver %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            base_station = baseStation(f_sampling , baude_rate) ;    % f_samp and baude rate of sender and receiver shoud same
            freq_data = base_station.filter_bank( data_received,freq_to_filter_out );
            down_samp_data_I = base_station.down_sampling_I(freq_data,freq_to_filter_out);
            down_samp_data_Q = base_station.down_sampling_Q(freq_data,freq_to_filter_out);
            avg_data_val_I = base_station.cal_avg_val(down_samp_data_I);
            avg_data_val_Q = base_station.cal_avg_val(down_samp_data_Q);

            [data_after_ml_I,data_after_ml_Q]= base_station.ml_rule(avg_data_val_I,avg_data_val_Q);
            %checking for cdma decoded sym data 
            decoded_cdma_data_I = base_station.cdma_decoder( data_after_ml_I, walsh_code);
            decoded_cdma_data_Q = base_station.cdma_decoder( data_after_ml_Q , walsh_code);

            count_error_I = 0 ;
            count_error_Q = 0 ;
            for i=1:length(decoded_cdma_data_I)
                if( decoded_cdma_data_I(i) ~= I(i)) 
                    count_error_I = count_error_I + 1 ; 
                elseif( decoded_cdma_data_Q(i) ~= Q(i))
                    count_error_Q = count_error_Q + 1 ;
                end 
            end
            data_ = base_station.sym_to_data_bits(decoded_cdma_data_I,decoded_cdma_data_Q);
            bit_error_count = 0 ;
            for i=1:length(data_)
                if( data_(i) ~= bin_data_to_send(i))
                    bit_error_count = bit_error_count + 1;
                end 
            end
            total_sym_error = [ total_sym_error , count_error_I + count_error_Q] ;
            total_bit_error = [ total_bit_error , bit_error_count];
        
        end
        subplot(1,2,1);
        plot(snr , total_sym_error);
        title('Symbol Error V/S SNR');
        xlabel('SNR in db');
        ylabel('Number of symbol in error');
        subplot(1,2,2);
        plot(snr , total_bit_error);
        title('Bit error VS SNR');
        xlabel('SNR in db');
        ylabel('Number of Bit in error');
end 