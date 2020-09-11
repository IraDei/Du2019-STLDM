function [aviobj] = img2video(img_seq, nfrm, dir_opt, aviname, ext, frame_rate)
%IMG2VIDEO 
% CreatVideoFromPic(dn, picformat,aviname)
% ��ĳ���ļ�����ĳ�ָ�ʽ������ͼƬ�ϳ�Ϊ��Ƶ�ļ�
% dn : �洢ͼƬ���ļ���
% picformat : Ҫ��ȡ��ͼƬ�ĸ�ʽ����png��jpg����ʽ���ַ�������
% aviname   : �洢����Ƶ���ļ���
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
                error('����ͼƬ�ĳߴ�Ҫ��ͬ����');
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

