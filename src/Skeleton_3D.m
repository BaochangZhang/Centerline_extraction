% V1  the vascular segmentation result with logical data-type
% Use fastmarching to find the skeleton
S=skeleton(V1);
% Show the iso-surface of the vessels
figure,
FV = isosurface(V1,0.5);
patch(FV,'facecolor',[1 0 0],'facealpha',0.3,'edgecolor','none');
view(3)
camlight
% Display the skeleton
hold on;
for i=1:length(S)
    L=S{i};
    plot3(L(:,2),L(:,1),L(:,3),'-','Color',rand(1,3));
end
save('centerline_data.mat','S','V1');