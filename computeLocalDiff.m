function [gdiff, MT] = computeLocalDiff(img, lcmBlocks)
%computeLocalDiff 
% Compute 'grayscale difference' for input image with pre-defined local contrast block.
% This function serves 'STLDM' with a most simple format.
% 
[imgR, imgC, ~] = size(img);
blk_qty = 8;    % 8 neighbor blocks and last for central target window
MT = zeros(imgR,imgC);  % max pixel grayscale in target blocks
gdiff = zeros(imgR, imgC, blk_qty);

% compute MT
for y = 1:imgR
    ymin = max(1, y + lcmBlocks.dymin(9));
    ymax = min(imgR, y + lcmBlocks.dymax(9));
    for x = 1:imgC
        % average grayscale in neighbor block
        xmin = max(1, x + lcmBlocks.dxmin(9));
        xmax = min(imgC, x + lcmBlocks.dymax(9));
        blk_pth = img(ymin:ymax, xmin:xmax);
        MT(y, x) = max(blk_pth,[],'all');
    end
end

% Compute 'gray difference'
for b = 1:blk_qty
    for y = 1:imgR
        ymin = max(1, y + lcmBlocks.dymin(b));
        ymax = min(imgR, y + lcmBlocks.dymax(b));
        for x = 1:imgC
            % average grayscale in neighbor block
            xmin = max(1, x + lcmBlocks.dxmin(b));
            xmax = min(imgC, x + lcmBlocks.dymax(b));
            blk_pth = img(ymin:ymax, xmin:xmax);
            blk_mean = mean(blk_pth,'all');
            gdiff(y, x, b) = MT(y, x) - blk_mean;
        end
    end
end

end

