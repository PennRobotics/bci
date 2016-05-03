load subject/subject1
load subject/subject2
load subject/subject3

delete(gcp('nocreate'))
pool = parpool

Train_Glove_1(104000:105999, :) = [];
Train_Glove_2(104000:105999, :) = [];
Train_Glove_3(104000:105999, :) = [];

parfor phd3 = 1 : 120
    max_value = zeros(360, 3);
    phase = phd3 * 3; 
    max_correlation = zeros(3,5);
    for max_t = logspace(-5,5,101);
        t = linspace(0, max_t, 308000);
        ft = sin(t + (phase * pi / 180));
        ccS1F1 = corr(ft', Train_Glove_1(:, 1));
        ccS1F2 = corr(ft', Train_Glove_1(:, 2));
        ccS1F3 = corr(ft', Train_Glove_1(:, 3));
        ccS1F4 = corr(ft', Train_Glove_1(:, 4));
        ccS1F5 = corr(ft', Train_Glove_1(:, 5));
        ccS2F1 = corr(ft', Train_Glove_2(:, 1));
        ccS2F2 = corr(ft', Train_Glove_2(:, 2));
        ccS2F3 = corr(ft', Train_Glove_2(:, 3));
        ccS2F4 = corr(ft', Train_Glove_2(:, 4));
        ccS2F5 = corr(ft', Train_Glove_2(:, 5));
        ccS3F1 = corr(ft', Train_Glove_3(:, 1));
        ccS3F2 = corr(ft', Train_Glove_3(:, 2));
        ccS3F3 = corr(ft', Train_Glove_3(:, 3));
        ccS3F4 = corr(ft', Train_Glove_3(:, 4));
        ccS3F5 = corr(ft', Train_Glove_3(:, 5));
        current_corr = [ccS1F1 ccS1F2 ccS1F3 ccS1F4 ccS1F5; ...
                        ccS2F1 ccS2F2 ccS2F3 ccS2F4 ccS2F5; ... 
                        ccS3F1 ccS3F2 ccS3F3 ccS3F4 ccS3F5];
        max_correlation = max(max_correlation, current_corr);
        if any(current_corr == max_correlation)
           max_value(phase,:) = [phase max_t max(max(current_corr))]; 
        end
    end
    disp(max(max_value))
end

