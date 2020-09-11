function [aviobj] = img2video(img_seq, nfrm, dir_opt, aviname, ext, frame_rate)
%IMG2VIDEO 
% CreatVideoFromPic(dn, picformat,aviname)
% 将某个文件夹下某种格式的所有图片合成为视频文件
% dn : 存储图片的文件夹
% picformat : 要读取的图片的格式，如png、jpg等形式，字符串数组
% aviname   : 存储的视频的文件名
% example : CreatVideoFromPic( './', 'png','presentation.avi');
   
    avi_dir = [dir_opt aviname];
    aviobj = VideoWriter([avi_dir ext]);
    aviobj.FrameRate = frame_rate;
    open(aviobj);
    for i=1:nfrm
        if ~isempty(aviobj.Height)
            if size(img_seq(:,:,i),1) ~= aviobj.Height || size(img_seq(:,:,i),2) ~= aviobj.Width
                close(aviobj);
                delete( aviname )
                error('所有图片的尺寸要相同！！');
            end
        end
        
        %fprintf('frame %g: min/max = %g/%g\n', i, min(img_seq(:,:,i),[],'all'), max(img_seq(:,:,i),[],'all'));
        writeVideo(aviobj, img_seq(:,:,i));
%         try
%             writeVideo(aviobj, img_seq(:,:,i));
%         catch
%             fprintf('error at writing frame %g.\n', i);
%         end
    end
    close(aviobj);
end

