load axon_fired_4_20

YY1 = predicted_dg{1};
YY2 = predicted_dg{2};
YY3 = predicted_dg{3};

%stdev1 = std(YY1);
%stdev2 = std(YY2);
%stdev3 = std(YY3);

%mean1 = mean(YY1);
%mean2 = mean(YY2);
%mean3 = mean(YY3);

%L1 = size(YY1, 1);
%L2 = size(YY2, 1);
%L3 = size(YY3, 1);

%Y1_scaled = (YY1 - ones(L1, 1) * mean(YY1)) ./ (ones(L1, 1) * std(YY1));
%Y2_scaled = (YY2 - ones(L2, 1) * mean(YY2)) ./ (ones(L2, 1) * std(YY2));
%Y3_scaled = (YY3 - ones(L3, 1) * mean(YY3)) ./ (ones(L3, 1) * std(YY3));

Y1_max = zeros(size(YY1));
Y2_max = zeros(size(YY2));
Y3_max = zeros(size(YY3));

%for i = 1 : L1
%  [m, idx] = max(Y1_step(i, :));
%  Y1_max(i, idx) = min(max(min(m, 10 * C * stdev1(idx)), -1), 5);
%end
%for i = 1 : L2
%  [m, idx] = max(Y2_step(i, :));
%  Y2_max(i, idx) = min(max(min(m, 10 * C * stdev2(idx)), -1), 5);
%end
%for i = 1 : L3
%  [m, idx] = max(Y3_step(i, :));
%  Y3_max(i, idx) = min(max(min(m, 10 * C * stdev3(idx)), -1), 5);
%end

for i = 1 : L1
  [m, idx] = max(YY1(i, :));
  Y1_max(i, idx) = m;
end
for i = 1 : L2
  [m, idx] = max(YY2(i, :));
  Y2_max(i, idx) = m;
end
for i = 1 : L3
  [m, idx] = max(YY3(i, :));
  Y3_max(i, idx) = m;
end

clear predicted_dg
predicted_dg{1} = Y1_max;
predicted_dg{2} = Y2_max;
predicted_dg{3} = Y3_max;

