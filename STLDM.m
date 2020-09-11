function [] = STLDM(path, ext, blk_rnk, tstep, segK)
%STLDM
% A matlab R2018b realisation on 'Infrared Moving Small-Target Detection Using
% Spatial-Temporal Local Difference Measure' by Du P, Hamdulla A. on 
% IEEE Geoscience and Remote Sensing Letters. 2019 Dec 4..
%
% params:
%   'blkrnk' - rank of sample window for local contrast block.
%   'tstep' - temporal interval for interframe comparison, refers 'l' as 
%   the stride of forward/backward frame.
%
% sugggested param set in original paper: [blk_rnk, tstep, segK] = [1, 5, 5~15]
% required funcs: videoInread, genLCMBlocks, out_bw, img2video
%

opt_res = true; % output threshold segentation result into video
[frame_data, n_frm, imgR, imgC] = videoInread(path, ext);

% init LCM sampling blocks
blk_centre = [-1 -1; -1 0; -1 +1; 0 +1; +1 +1; +1 0; +1 -1; 0 -1; 0 0;];
nblk_qty = 8;
lcmBlocks = genLCMBlocks(blk_rnk, blk_centre);

% 1. window-slide on each frame to compute components for DMAP and IMAP
frame_lcm_diff = zeros(imgR, imgC, nblk_qty, n_frm);
frame_wgt_mass = zeros(imgR, imgC, n_frm);
direct_pair = [1 5; 2 6; 3 7; 4 8;];
direct_cp = size(direct_pair, 1);
st_grad = zeros(imgR, imgC, direct_cp); % 'dj' in Eq.4, this is TEMPORAL variable
% DMAP, IMAP, and STLDM
DMAP = zeros(imgR, imgC, n_frm);
IMAP = zeros(imgR, imgC, n_frm);
STLDM = zeros(imgR, imgC, n_frm);

% bw and outputs
bw = zeros(imgR, imgC, n_frm); % segmentation result
for k = 1:n_frm
    % A. Compute grayscale difference according to Eq.1~Eq.3
    [frame_lcm_diff(:,:,:,k), frame_wgt_mass(:,:,k)] = computeLocalDiff(frame_data(:,:,k), lcmBlocks);
    
    % compute temporal directional difference (Eq.4)
    bidx = max(1, k - tstep);
    fidx = min(n_frm, k + tstep);
    for j = 1:4
        st_grad(:,:,j) = (frame_lcm_diff(:,:,j,k) - frame_lcm_diff(:,:,j,fidx)).^3 + ...
           	(frame_lcm_diff(:,:,j+4,k) - frame_lcm_diff(:,:,j+4,bidx)).^3;
    end
    
    % compute DMAP, IMAP and normalize them
    max_dmp = 0;
    max_imp = 0;
    for y = 1:imgR
        for x = 1:imgC
            % DMAP
            DMAP(y, x, k) = max(st_grad(y,x,:),[],'all');
            if DMAP(y, x, k)>max_dmp
                max_dmp = DMAP(y, x, k);
            end
            
            % IMAP
            % compute interframe grayscale variation of widget (Eq.7~10)
            wgt_seq = [frame_wgt_mass(y,x,bidx) frame_wgt_mass(y,x,k) frame_wgt_mass(y,x,fidx)];
            Imax = max(wgt_seq,[],'all');
            Imin = min(wgt_seq,[],'all');
            IMAP(y, x, k) = (Imax-Imin).^2;
            if IMAP(y, x, k)>max_imp
                max_imp = IMAP(y, x, k);
            end
        end
    end
    DMAP(:,:,k) = DMAP(:,:,k) / max_dmp;  % normalize DMAP
    IMAP(:,:,k) = IMAP(:,:,k) / max_imp;  % normalize IMAP
    STLDM(:,:,k) = DMAP(:,:,k).*IMAP(:,:,k);
    
    bw(:,:,k) = out_bw(STLDM(:,:,k), segK);
    
    % visualization 
    fhnd = figure(1);
    set(fhnd,'name',['frame' num2str(k)]);
    subplot(1,3,1);
    imshow(frame_data(:,:,k),[]);
    subplot(1,3,2);
    imshow(STLDM(:,:,k),[]);
    subplot(1,3,3);
    imshow(bw(:,:,k),[]);
end

if opt_res
    mkdir('results');
    img2video(bw, n_frm, [pwd '/results/'],[datestr(now, 30) '_k-' num2str(segK)],'.avi',25);
end
end

