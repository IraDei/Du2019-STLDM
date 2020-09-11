function [bw] = out_bw(out, k)
%OUT_BW 此处显示有关此函数的摘要
%   此处显示详细说明
out_avg = mean(out, 'all');
out_std = std(out, 0, 'all');
out_thd = out_avg + k * out_std;
bw = imbinarize(out, out_thd);
end

