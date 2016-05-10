%% SAVE TO FILE
save_file = 1;

disp('Saving predicted_dg{N} to output matfile')
predicted_dg{1} = y1_hat;
predicted_dg{2} = y2_hat;
predicted_dg{3} = y3_hat;

if save_file
  % inputstr = input('Save filename? ', 's');
  inputstr = 'final_output.mat';
  save(inputstr, 'predicted_dg')
  disp(['Saved to ' inputstr])
else
  disp('MATFILE WAS NOT SAVED!')
end
