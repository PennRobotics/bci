n =4; %Order of filter
Rp = 0.1; %Passband ripple
Rs = 40; %Stopband attenuation
Wp = 0.12;   %Normalized passband edge frequency
[b,a]=ellip(n,Rp,Rs,Wp,'low');
sub1_filtered = filter(b,a, Train_ECoG_1);
sub1_glove = filter(b,a, Train_Glove_1);
sub_1_test = filter(b,a, Test_ECoG_1);
