%% GENERATE OUTPUT SIGNAL USING PEAK SAMPLES
y1_hat = zeros(size(y1_delta));
y2_hat = zeros(size(y2_delta));
y3_hat = zeros(size(y3_delta));

y1_hat(:, 1) = conv(y1_delta(:, 1), S1F1, 'same');
y1_hat(:, 2) = conv(y1_delta(:, 2), S1F2, 'same');
y1_hat(:, 3) = conv(y1_delta(:, 3), S1F3, 'same');
y1_hat(:, 4) = conv(y1_delta(:, 4), S1F4, 'same');
y1_hat(:, 5) = conv(y1_delta(:, 5), S1F5, 'same');
y2_hat(:, 1) = conv(y2_delta(:, 1), S2F1, 'same');
y2_hat(:, 2) = conv(y2_delta(:, 2), S2F2, 'same');
y2_hat(:, 3) = conv(y2_delta(:, 3), S2F3, 'same');
y2_hat(:, 4) = conv(y2_delta(:, 4), S2F4, 'same');
y2_hat(:, 5) = conv(y2_delta(:, 5), S2F5, 'same');
y3_hat(:, 1) = conv(y3_delta(:, 1), S3F1, 'same');
y3_hat(:, 2) = conv(y3_delta(:, 2), S3F2, 'same');
y3_hat(:, 3) = conv(y3_delta(:, 3), S3F3, 'same');
y3_hat(:, 4) = conv(y3_delta(:, 4), S3F4, 'same');
y3_hat(:, 5) = conv(y3_delta(:, 5), S3F5, 'same');
