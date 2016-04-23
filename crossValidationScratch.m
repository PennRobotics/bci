function [ corr ] = crossValidationScratch( R, Train_ECoG, Train_Glove, numBin )
%crossValidationV1_0 : takes in ECoG and Glove and give crossvalidation
%correlation results.
%   Detailed explanation: to be added - Curently numBin is hardreseted to
%   be 2 (1 train, 1 test). Later update would allow user to choose higher
%   values such as numBin = 5 (4 train, 1 test).

    M = size(Train_ECoG, 1);
    vu = size(Train_ECoG, 2);
    N = M -size(R, 1) + 1;
    sprintf('\nM = %d\tvu = %d\tN = %d', M, vu, N)

    if (size(Train_ECoG, 1) ~= size(Train_Glove, 1))
       disp('\nError: Your ECoG and Glove Input have dimension mismatch')
       exit;
    end
    if (size(R, 1) ~= M - N + 1)
        disp('\nError: Your R matrix does not have correct row size in relationship to Train_ECoG')
        exit;
    end
    if (size(R, 2) ~= vu * N + 1)
        disp('\nError: Your R matrix does not have correct column size in relationship to Train_ECoG')
        exit;
    end
    
    ECoG_Train_Part = Train_ECoG(N:round(end/2)-1, :);
    ECoG_Test_Part = Train_ECoG(round(end/2)+N-1:end, :);
    Glove_Train_Part = Train_Glove(N:round(end/2)-1, :);
    Glove_Test_Part = Train_Glove(round(end/2)+N-1:end, :);
    
    R_Train = R(1:length(ECoG_Train_Part), :);
    R_Test = R(length(ECoG_Train_Part)+1:end, :);
    sprintf('\nR has size %dx%d, R_Train %dx%d, R_Test %dx%d', size(R, 1), size(R, 2), size(R_Train, 1), size(R_Train, 2), size(R_Test, 1), size(R_Test, 2))
    sprintf('\nR_Train has size %dx%d and Glove_Train_Part has size %dx%d', size(R_Train, 1), size(R_Train, 2), size(Glove_Train_Part, 1), size(Glove_Train_Part, 2))
    [beta, fitinfo] = mldivide( (R_Train' * R_Train), (R_Train' * Glove_Train_Part) );
    
    y_hat = R_Test * beta;
    corr = corr(y_hat, Glove_Test_Part);
    
    
end

