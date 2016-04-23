YY1 = predicted_dg{1};
span = 0.75;
for finger = 1:1:5
    sprintf('\nStarted\t%d-th finger', finger)
    figure
    hold on
    plot(YY1(:, finger));
    hold on
%     smooth_YY1 = smooth(YY1(:, finger);
    plot(smooth(YY1(:, finger), span, 'rloess'));
    sprintf('\nEnded\t%d-th finger', finger)
    legend('raw', 'smoothed');
    titlestring = sprintf('Finger %d - smoothed with span = %d', finger, span);
    title(titlestring);
    
end