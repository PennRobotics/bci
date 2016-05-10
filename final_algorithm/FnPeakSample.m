function [output] = PeakSample(input_y, idx_peak, A_peak, win_size, WindowFnName, shift)

input_padded = [zeros(win_size, 5); input_y; zeros(win_size, 5)];

idx_peak_shifted = idx_peak + win_size;
idx_start = idx_peak + (1/2) * win_size;
idx_end   = idx_peak + (3/2) * win_size;

WindowFnCall = [WindowFnName '(win_size + 1) * ones(1, 5)'];
Window = eval(WindowFnCall);

output_padded = zeros(size(input_padded)); % Initialize output

for i = 1 : length(idx_peak)
  finger_strength = sum(Window .* input_padded(idx_start(i) : idx_end(i), :));
  [~, finger_idx] = max(finger_strength);
  % finger_choice(i) = finger_idx;
  horz_impulse_location = 4000 * i + 1;
  % output_padded(idx_peak_shifted(i), finger_idx) = 0.2 * A_peak(i);
  % TODO(brwr): Add a R/L shift to horz_impulse_location to influence correlation!!!
  output_padded(horz_impulse_location + shift, finger_idx) = 1;

end

output = output_padded(1 + win_size : end - win_size, :);

end
