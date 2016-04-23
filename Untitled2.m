YY1 = predicted_dg{1};
span = 100;
for finger = 1:1:5
    figure
    hold on
    plot(YY1(:, finger));
    hold on
    plot(smooth(YY1(:, finger), span));
    legend('raw', 'smoothed');
    titlestring = sprintf('Finger %d - smoothed with span = %d', finger, span);
    title(titlestring);
end