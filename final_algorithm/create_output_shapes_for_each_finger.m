%% CREATE OUTPUT SHAPES FOR EACH FINGER
load subject1
load subject2
load subject3

% Remove unwanted time shift from training data
Train_Glove_1(104000:105999, :) = [];
Train_Glove_2(104000:105999, :) = [];
Train_Glove_3(104000:105999, :) = [];
% Shift Subject 3 glove waveforms right by 400 ms; assumes len(s2) == len(s3)
Train_Glove_3 = [zeros(400,5); Train_Glove_3];
Train_Glove_3 = Train_Glove_3(1:size(Train_Glove_2, 1),:);

S1F1 = sum(reshape(Train_Glove_1(:, 1), 4000, 77), 2);
S1F2 = sum(reshape(Train_Glove_1(:, 2), 4000, 77), 2);
S1F3 = sum(reshape(Train_Glove_1(:, 3), 4000, 77), 2);
S1F4 = sum(reshape(Train_Glove_1(:, 4), 4000, 77), 2);
S1F5 = sum(reshape(Train_Glove_1(:, 5), 4000, 77), 2);

S2F1 = sum(reshape(Train_Glove_2(:, 1), 4000, 77), 2);
S2F2 = sum(reshape(Train_Glove_2(:, 2), 4000, 77), 2);
S2F3 = sum(reshape(Train_Glove_2(:, 3), 4000, 77), 2);
S2F4 = sum(reshape(Train_Glove_2(:, 4), 4000, 77), 2);
S2F5 = sum(reshape(Train_Glove_2(:, 5), 4000, 77), 2);
S3F1 = sum(reshape(Train_Glove_3(:, 1), 4000, 77), 2);
S3F2 = sum(reshape(Train_Glove_3(:, 2), 4000, 77), 2);
S3F3 = sum(reshape(Train_Glove_3(:, 3), 4000, 77), 2);
S3F4 = sum(reshape(Train_Glove_3(:, 4), 4000, 77), 2);
S3F5 = sum(reshape(Train_Glove_3(:, 5), 4000, 77), 2);

S1F1 = mean([3*ones(4000,1), (4 / max(S1F1)) * S1F1], 2); %% TODO(brwr):
S1F2 = mean([3*ones(4000,1), (4 / max(S1F2)) * S1F2], 2); %  Average of
S1F3 = mean([3*ones(4000,1), (4 / max(S1F3)) * S1F3], 2); %  square wave
S1F4 = mean([3*ones(4000,1), (4 / max(S1F4)) * S1F4], 2); %  and detected
S1F5 = mean([3*ones(4000,1), (4 / max(S1F5)) * S1F5], 2); %  shape. Fix
S2F1 = mean([3*ones(4000,1), (4 / max(S2F1)) * S2F1], 2); %  alignment,
S2F2 = mean([3*ones(4000,1), (4 / max(S2F2)) * S2F2], 2); %  then delete
S2F3 = mean([3*ones(4000,1), (4 / max(S2F3)) * S2F3], 2); %  square wave
S2F4 = mean([3*ones(4000,1), (4 / max(S2F4)) * S2F4], 2); %  from here!
S2F5 = mean([3*ones(4000,1), (4 / max(S2F5)) * S2F5], 2);
S3F1 = mean([3*ones(4000,1), (4 / max(S3F1)) * S3F1], 2);
S3F2 = mean([3*ones(4000,1), (4 / max(S3F2)) * S3F2], 2);
S3F3 = mean([3*ones(4000,1), (4 / max(S3F3)) * S3F3], 2);
S3F4 = mean([3*ones(4000,1), (4 / max(S3F4)) * S3F4], 2);
S3F5 = mean([3*ones(4000,1), (4 / max(S3F5)) * S3F5], 2);

S1F1(S1F1 < 0) = 0; % Keep waveforms positive
S1F2(S1F2 < 0) = 0;
S1F3(S1F3 < 0) = 0;
S1F4(S1F4 < 0) = 0;
S1F5(S1F5 < 0) = 0;

S2F1(S2F1 < 0) = 0;
S2F2(S2F2 < 0) = 0;
S2F3(S2F3 < 0) = 0;
S2F4(S2F4 < 0) = 0;
S2F5(S2F5 < 0) = 0;

S3F1(S3F1 < 0) = 0;
S3F2(S3F2 < 0) = 0;
S3F3(S3F3 < 0) = 0;
S3F4(S3F4 < 0) = 0;
S3F5(S3F5 < 0) = 0;

save('final_shapes.mat','S1F1','S1F2','S1F3','S1F4','S1F5', ...
                        'S2F1','S2F2','S2F3','S2F4','S2F5', ...
                        'S3F1','S3F2','S3F3','S3F4','S3F5')
