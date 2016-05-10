%% SHOW RESULTS
show_resulting_plots = 0;

if show_resulting_plots
  figure(1); clf reset
    subplot(2,1,1); findpeaks(analog1,'MinPeakProminence',2); xbound = xlim;
    subplot(2,1,2); plot(y1_hat); xlim(xbound); grid on; legend 1 2 3 4 5
  figure(2); clf reset
    subplot(2,1,1); findpeaks(analog2,'MinPeakProminence',2); xbound = xlim;
    subplot(2,1,2); plot(y2_hat); xlim(xbound); grid on; legend 1 2 3 4 5
  figure(3); clf reset
    subplot(2,1,1); findpeaks(analog3,'MinPeakProminence',2); xbound = xlim;
    subplot(2,1,2); plot(y3_hat); xlim(xbound); grid on; legend 1 2 3 4 5
else
  disp('PLOTS DISABLED!')
end
