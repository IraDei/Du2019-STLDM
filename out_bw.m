function [bw] = out_bw(out, k)
%OUT_BW �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
out_avg = mean(out, 'all');
out_std = std(out, 0, 'all');
out_thd = out_avg + k * out_std;
bw = imbinarize(out, out_thd);
end

