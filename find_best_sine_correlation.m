pool = parpool
parfor phase = 0:359
max_correlation = zeros(3,5);
for max_t = logspace(-5,5,1001);
t = linspace(0, max_t, 308000);
ft = sin(t + (phase * pi / 180));
ccS1F1 = corr(ft', glove1(:, 1));
ccS1F2 = corr(ft', glove1(:, 2));
ccS1F3 = corr(ft', glove1(:, 3));
ccS1F4 = corr(ft', glove1(:, 4));
ccS1F5 = corr(ft', glove1(:, 5));
ccS2F1 = corr(ft', glove2(:, 1));
ccS2F2 = corr(ft', glove2(:, 2));
ccS2F3 = corr(ft', glove2(:, 3));
ccS2F4 = corr(ft', glove2(:, 4));
ccS2F5 = corr(ft', glove2(:, 5));
ccS3F1 = corr(ft', glove3(:, 1));
ccS3F2 = corr(ft', glove3(:, 2));
ccS3F3 = corr(ft', glove3(:, 3));
ccS3F4 = corr(ft', glove3(:, 4));
ccS3F5 = corr(ft', glove3(:, 5));
current_corr = [ccS1F1 ccS1F2 ccS1F3 ccS1F4 ccS1F5; ...
                ccS2F1 ccS2F2 ccS2F3 ccS2F4 ccS2F5; ... 
                ccS3F1 ccS3F2 ccS3F3 ccS3F4 ccS3F5];
