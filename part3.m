% TODO(brwr): Under construction

sub_1_train_final = [sub_1_train_MA , sub_1_train_FD];
sub_1_glove_final = [sub_1_glove_MA , sub_1_glove_FD];


for i = 1: 374
      sub1_train_decimated(i, :) = decimate(sub_1_final(:, i), 50);
end

sub1_train_decimated = sub1_train_decimated';

for j = 1:5
    sub1_glove_decimated(j, :) = decimate(sub_1_glove_final(:, j), 50);
end

sub1_glove_decimated = sub1_glove_decimated';
