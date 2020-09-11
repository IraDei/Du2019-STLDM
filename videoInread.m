function [frame_data, n_frm, imgR, imgC] = videoInread(path, ext)
%videoInread
% Read frame sequence in given folder with specified extend type into
% memory.
% 
%% set path
addpath(path);
img_dir = fullfile([path '/*.' ext]);

% init image sequence/video consts
frame_list=dir(img_dir);
n_frm = length(frame_list); % total frame quantity

im0 = imread(frame_list(1).name);
[imgR, imgC, dim] = size(im0);
frame_data = zeros(imgR, imgC, n_frm);
%frame_data(:,:,1) = im0(:,:,1);
% load all image files
for k = 1:n_frm
    %frame_data(:,:,k) = rgb2gray(imread(frame_list(k).name));
    frame_data(:,:,k) = rgb2gray(imread([num2str(k-1) '.' ext]));
end

end

