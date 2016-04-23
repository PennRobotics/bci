function [output] = PeakSampleManual(input_y, idx_peak, win_size, WindowFnName)

figure(42); clf; hold off
plot( 5.0 + input_y(:, 1)); hold on
plot( 2.5 + input_y(:, 2));
plot( 0.0 + input_y(:, 3));
plot(-2.5 + input_y(:, 4));
plot(-5.0 + input_y(:, 5)); plot([idx_peak; idx_peak]', ylim, 'r')
legend 1 2 3 4 5

output = zeros(size(input_y)); % Initialize output
keyboard_input = zeros(size(idx_peak));

xlimits = xlim;
for i = 1 : length(idx_peak)
  xlimit = [idx_peak(i) - 6000, idx_peak(i) + 7000];
  xlimit = min(max(xlimit, 1), xlimits(2));
  disp(xlimit)
  xlim(xlimit)
  inputstr = ['Which finger is peak ', num2str(i), '? '];
  keyboard_input = input(inputstr, 's');
  finger_choice(i) = str2num(keyboard_input);
  output(idx_peak(i), finger_choice(i)) = 1;
end

end