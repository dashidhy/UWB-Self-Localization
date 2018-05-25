clear all; close all; clc

filename = struct2cell(dir('./data525/*.txt'))';
filename = filename(:, 1);

num = length(filename);

table = zeros(num);

for i = 1:num

    node = filename{i}(1);
    
    fid = fopen(['./data525/', filename{i}], 'r');
    data_c = fgetl(fid);
    fclose(fid);
    flength = length(data_c);
    pin = 1;
    d_c = zeros(1, num);
    count = zeros(1, num);
    
    while (pin + 34) < flength
        if min(data_c(pin:(pin + 34)) == ['AA 55 A5 5A 02 0', node, ' 01 00 00 05 3C 00']) == 1
            pin = pin + 48;
			for j = 1:5
				node_c = hex2dec(data_c(pin:pin + 1));
                if node_c > 5
                    pin = pin + 15;
                    continue
                end
				node_c = node_c + 1;
				t = hex2dec([data_c(pin + 12:pin + 13), data_c(pin + 9:pin + 10), data_c(pin + 6:pin + 7), data_c(pin + 3:pin + 4)]);
				pin = pin + 15;
				if t > 19000
					continue;
				end
				d_c(node_c) = d_c(node_c) + t;
				count(node_c) = count(node_c) + 1;
            end
        end
        pin = pin+3;
        if max(count) == 10
            break;
        end
    end
    
	table(str2num(node) + 1, :) = d_c ./ count;
    
end

for i = 1:num
    table(i, i) = 0;
end
table = (table + table.') ./ 2;

t = table(2, :);
table(2, :) = table(3, :);
table(3, :) = t;

t = table(:, 2);
table(:, 2) = table(:, 3);
table(:, 3) = t;

M = Corr(table) ./ 100;
load('ex525_bias.mat');
M = M - bias525;