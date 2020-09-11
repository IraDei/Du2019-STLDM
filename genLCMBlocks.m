function [lcmBlocks] = genLCMBlocks(k, block_ofs)
%GENLCMBLOCKS 
% Generate sampling blocks with neighbor position offsets in reference of kernel
% pixel of sliding window in manner of 'octo background blocks girdle'.
%
% params:
%   'k' - rank of single sample block, dist between adjacent blocks equals to '2k+1'
%   'block_ofs' - n*2 matrix defines block index and sequential arrangement
%   of smple blocks, '1' unit offset equals to edge length of single block.
%

unit_len = k * 2 + 1;
blk_qty = size(block_ofs, 1);

for b = 1:blk_qty
    dev_y = ones(unit_len) * block_ofs(b ,1);
    dev_x = ones(unit_len) * block_ofs(b ,2);
    lcmBlocks.dymin(b) = dev_y(1, 1) - k;
    lcmBlocks.dymax(b) = dev_y(1, 1) + k;
    lcmBlocks.dxmin(b) = dev_x(1, 1) - k;
    lcmBlocks.dxmax(b) = dev_x(1, 1) + k;
    for y = -k:k
        ly = y + k + 1;
        for x = -k:k
            lx = x + k + 1;
            dev_y(ly, lx) = dev_y(ly, lx) + y;
            dev_x(ly, lx) = dev_x(ly, lx) + x;
        end
    end
    lcmBlocks.blk_yd(:,:,b) = dev_y;
    lcmBlocks.blk_xd(:,:,b) = dev_x;
end

end

