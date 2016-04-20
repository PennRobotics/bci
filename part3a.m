load axon_fired

YY1 = predicted_dg{1};
YY2 = predicted_dg{2};
YY3 = predicted_dg{3};

stdev1 = std(YY1);
stdev2 = std(YY2);
stdev3 = std(YY3);

mean1 = mean(YY1);
mean2 = mean(YY2);
mean3 = mean(YY3);

L1 = size(YY1, 1);
L2 = size(YY2, 1);
L3 = size(YY3, 1);

Y1_scaled = (YY1 - ones(L1, 1) * mean(YY1)) ./ (ones(L1, 1) * std(YY1));
Y2_scaled = (YY2 - ones(L2, 1) * mean(YY2)) ./ (ones(L2, 1) * std(YY2));
Y3_scaled = (YY3 - ones(L3, 1) * mean(YY3)) ./ (ones(L3, 1) * std(YY3));

C = 2;
Y1_step = round(C * Y1_scaled);
Y2_step = round(C * Y2_scaled);
Y3_step = round(C * Y3_scaled);

clear predicted_dg
predicted_dg{1} = Y1_step;
predicted_dg{2} = Y2_step;
predicted_dg{3} = Y3_step;
