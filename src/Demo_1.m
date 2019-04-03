clear;
load('centerline.mat')
MetaDataFilepath =strcat( '/Users/zbc/Desktop/project1/1_tof/TOF-1/WAN_Liwen_TOF.mhd');
[Image_TOF, ~,~,tof_info] = readMhd(MetaDataFilepath);
Tof_Origin = tof_info.Offset;
Tof_TransformMatrix =  reshape(tof_info.TransformMatrix,[3,3])';
Tof_Spacing = tof_info.PixelDimensions;

MetaDataFilepath =strcat( '/Users/zbc/Desktop/project1/1_tof/SPACE-1/WAN_Liwen_T1.mhd');
[Image_T1, ~,~,T1_info] = readMhd(MetaDataFilepath);
T1_Origin= T1_info.Offset;
T1_TransformMatrix =  reshape(T1_info.TransformMatrix,[3,3])';
T1_Spacing = T1_info.PixelDimensions;
[V1, centerline1,V2,centerline2] = trans_space( V1, T1_info,S,tof_info);