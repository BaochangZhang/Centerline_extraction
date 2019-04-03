function [V1, centerline1,V2,centerline2] = trans_space( V1, Space1_info, centerline1,Space2_info)
% Written by  Baochang Zhang
% E-mail：bc.zhang@siat.ac.cn
    V2 = zeros(Space2_info.Dimensions);

    Space1_Origin = Space1_info.Offset;
    Space1_TransformMatrix =  reshape(Space1_info.TransformMatrix,[3,3])';
    Space1_Spacing = Space1_info.PixelDimensions;

    Space2_Origin = Space2_info.Offset;
    Space2_TransformMatrix =  reshape(Space2_info.TransformMatrix,[3,3])';
    Space2_Spacing = Space2_info.PixelDimensions;
    Space2_dims = Space2_info.Dimensions;

    [V1_listI,V1_listJ,V1_listK] = ind2sub(size(V1),find(V1==1));

    for i= 1:length(V1_listI)
        P_ijk_s1 = [V1_listI(i),V1_listJ(i),V1_listK(i)]-1;
        P_ras= P_ijk_s1.*Space1_Spacing*Space1_TransformMatrix+Space1_Origin;
        P_ijk_s2 = round(((P_ras-Space2_Origin)/Space2_TransformMatrix)./Space2_Spacing)+1;           
        if 0<P_ijk_s2(1) && P_ijk_s2(1)<=Space2_dims(1) && 0<P_ijk_s2(2) && P_ijk_s2(2)<=Space2_dims(2) && 0<P_ijk_s2(3) && P_ijk_s2(3)<=Space2_dims(3) 
            V2(P_ijk_s2(1),P_ijk_s2(2),P_ijk_s2(3))=V1(V1_listI(i), V1_listJ(i),V1_listK(i));
        end
    end
    % 中心线变换
    S = centerline1;
    fid=fopen('centerline_world.txt','wt');
    for i=1:length(S)
        L=S{i};
        fprintf(fid,'BranchID:%d\n',i);
        fprintf(fid,'Points_Number:%d\n',length(L));
        fprintf(fid,'Points_Order_world_coordinates: X Y Z\n');
        for j=1:length(L)
            P_ijk = [L(j,1)-1, L(j,2)-1, L(j,3)-1];
            P_ras= P_ijk.*Space1_Spacing*Space1_TransformMatrix+Space1_Origin;
            fprintf(fid,'%f\t',P_ras(1));
            fprintf(fid,'%f\t',P_ras(2));
            fprintf(fid,'%f\n',P_ras(3));
        end
    end

    % save to ijk to image coordinates(T1)
    centerline2=S;
    fid=fopen('centerline_Spacing2.txt','wt');
    for i=1:length(S)
        L=S{i};
        L2=L;
        fprintf(fid,'the origin of coordinates: [0 0 0]\n');
        fprintf(fid,'BranchID:%d\n',i);
        fprintf(fid,'Points_Number:%d\n',length(L));
        fprintf(fid,'Points_Order_T1_image_coordinates: X Y Z\n');
        for j=1:length(L)
            P_ijk_sp1 = [L(j,1)-1, L(j,2)-1, L(j,3)-1];
            P_ras= P_ijk_sp1.*Space1_Spacing*Space1_TransformMatrix+Space1_Origin;
            P_ijk_sp2 = ((P_ras-Space2_Origin)/Space2_TransformMatrix)./Space2_Spacing;
            fprintf(fid,'%f\t',P_ijk_sp2(1));
            fprintf(fid,'%f\t',P_ijk_sp2(2));
            fprintf(fid,'%f\n',P_ijk_sp2(3));
            L2(j,:)=P_ijk_sp2+1;
        end
        centerline2{i} = L2;
    end
    % save to ijk to image coordinates(Tof)
    fid=fopen('centerline_Spacing1.txt','wt');
    for i=1:length(S)
        L=S{i};
        fprintf(fid,'the origin of coordinates: [0 0 0]\n');
        fprintf(fid,'BranchID:%d\n',i);
        fprintf(fid,'Points_Number:%d\n',length(L));
        fprintf(fid,'Points_Order_TOF_image_coordinates: X Y Z\n');
        for j=1:length(L)
            P_ijk_sp1 = [L(j,1)-1, L(j,2)-1, L(j,3)-1];
            fprintf(fid,'%f\t',P_ijk_sp1(1));
            fprintf(fid,'%f\t',P_ijk_sp1(2));
            fprintf(fid,'%f\n',P_ijk_sp1(3));
        end
    end
end
