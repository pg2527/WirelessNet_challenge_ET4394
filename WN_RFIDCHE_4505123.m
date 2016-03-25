%RFID Reader->TAG and TAG->Reader Message Decoding
%Make sure 'signal.txt' is in the present working directoy


%**************RFID R->T & T->R MESSAGE DECODING*************
%Commands to clean the variables  and close previous windows
clear
clc
close all
%Extracting the trace from the file
mess_info = importdata('signal') ;
%Checking the length of trace to validate
length(mess_info);
% Generating Breakpoints for packets
break_range=1500; % Range to break the total response into individual packets
index=1;
packets(index)=1; % storing breakpoints for packets
for i = 2: length(mess_info)
    if (mess_info(i-1) < 0.6 && mess_info(i) >= 0.6)
        %Defininf start location
        s_loc = i; 
        for bit_index=i:length(mess_info)
            if(mess_info(bit_index) < 0.6)
                break;
            end
        end
        i=bit_index;
        %Defining End location 
        e_loc = bit_index;  
        if(e_loc-s_loc > break_range)
            index=index+1;
            packets(index)=s_loc;
            index=index+1;
            packets(index)=bit_index;
        end
    end
end
%Displaying the breakpoints for the received trace
break_points = packets();
%Analysing and Deconding the R-T and T-R responses
for num=2:length(packets)
    new_packet=mess_info(packets(num-1):packets(num));
    
    pw = pulsewidth(new_packet,'Polarity','Negative'); %calculating pulse width
    tari=round(2.2*median(pw)); % calculating tari
    j=1;
    p_low_level(j)=0;
    min(new_packet);
    len=length(new_packet);
    k=1;
    %Analysing reader to tag responses
    if(min(new_packet)<0.02)
        for i=1:len
            if(new_packet(i)<0.02)
                j=j+1;
                p_low_level(j)=i;
            end
        end
        k=1;
        for i=2:length(p_low_level)
            if((p_low_level(i)-p_low_level(i-1) > (2*tari)) && (p_low_level(i)-p_low_level(i-1) < (2.5*tari)))
                bit_seq(k)=1;
                k=k+1;
            elseif((p_low_level(i)-p_low_level(i-1) >(1*tari)) && (p_low_level(i)-p_low_level(i-1) < (1.5*tari)))
                bit_seq(k)=0;
                k=k+1;
            end
        end
        a = 'Writing Bit-sequence from Reader to Tag';
        disp(a)
        p_seq_rt= bit_seq()
        
        % Analaysing Tag to reader responses
    else
        
        % Calculating pulse-width with positive polarity
        pw1_1 = pulsewidth(new_packet);
        %Calculating Pulse-width with Negative polarity
        pw2 = pulsewidth(new_packet,'Polarity','Negative');
        v_tari= round(1.5*(min(pw1_1)));
        %Generating bit sequence with the help of pulse-widths
        for i=4:length(pw1_1)
            if((pw1_1(i)> (1.1*v_tari)) && (pw1_1(i) < (2*v_tari)))
                if (pw2(i) >(1.1*v_tari)) && (pw2(i) <(2*v_tari))
                    bit_seq(k)=1;
                    bit_seq(k+1)=1;
                    k=k+2;
                else
                    bit_seq(k)=1;
                    k=k+1;
                end
            elseif((pw1_1(i)> (0.5*v_tari)) && (pw1_1(i) < (0.8*v_tari)))
                if((pw2(i) >(0.5*v_tari)) &&(pw2(i) <(0.8*v_tari)))
                    bit_seq(k)=0;
                    k=k+1;
                elseif(pw2(i) >(1.1*v_tari)) && (pw2(i) <(2*v_tari))
                    bit_seq(k)=0;
                    bit_seq(k+1)=1;
                    k=k+2;
                else
                    bit_seq(k)=0;
                    k=k+1
                end
                
            end
        end
        b = 'Writing Bit-sequence from Tag to Reader';
        disp(b)
        p_seq_tr= bit_seq()
    end
    %Generating sub-plots of the packets and the bit-sequences.
    % Bit sequences(R->T):Eliminated preamble, training data for Display
    % Bit sequences(T->R):Preamble and TAG data like 1010V eliminated for Display
    figure(num-1)
    subplot(2,1,1);
    plot(new_packet);
    subplot(2,1,2)
    x=1:1:length(bit_seq);
    stem(x,bit_seq)
    clear bit_seq;
end
%Displaying the Output
str_0 ='On the basis of received bit sequences(without preamble and training data)';
disp(str_0)
str_1 = 'In 1st Reader to Tag sequence,first Ack is received(01)';
disp(str_1)
str_2 = 'In 1st Tag to Reader reply,first 1010V TAG is received ';
disp(str_2)
str_3 ='In 2nd Reader to Tag sequence, first Req_RN(1100000)' ;
disp(str_3)
str_4 ='2nd Tag to Reader Reply';
disp(str_4)
