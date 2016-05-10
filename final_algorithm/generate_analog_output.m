%% GENERATE OUTPUT
disp('Generate Output (Linear Regression)')
Y1_hat = X1 * beta1;
Y2_hat = X2 * beta2;
Y3_hat = X3 * beta3;

disp('Pad Outputs')
% TODO(brwr): Is padding the ends the best way to do this?
Y1_Final = [repmat(Y1_hat(1, :),N,1); Y1_hat; repmat(Y1_hat(end, :),N,1)];
Y2_Final = [repmat(Y2_hat(1, :),N,1); Y2_hat; repmat(Y2_hat(end, :),N,1)];
Y3_Final = [repmat(Y3_hat(1, :),N,1); Y3_hat; repmat(Y3_hat(end, :),N,1)];

L1 = size(Test_ECoG_1, 1);
L2 = size(Test_ECoG_2, 1);
L3 = size(Test_ECoG_3, 1);

disp('Output PCHIP')
% PCHIP is similar to spline but generally does not overshoot vertically
YY1 = pchip(linspace(0, L1, size(Y1_Final, 1)), Y1_Final', linspace(0, L1, L1))';
YY2 = pchip(linspace(0, L2, size(Y2_Final, 1)), Y2_Final', linspace(0, L2, L2))';
YY3 = pchip(linspace(0, L3, size(Y3_Final, 1)), Y3_Final', linspace(0, L3, L3))';

predicted_dg{1} = YY1;
predicted_dg{2} = YY2;
predicted_dg{3} = YY3;

disp('Saving final_axon_fired.mat (analog output)')
save('final_axon_fired_analog.mat', 'predicted_dg');

disp('Done.')
disp(' ')
disp(' ')
