function Interpolation_point = Downsample(Depth,HR_value,Downsampling_multiple)

% Downsample the depth
Down_Depth=downsample(Depth,Downsampling_multiple); 

% Downsample the attribute values
LR_value=downsample(HR_value,Downsampling_multiple);
Interpolation_point=[Down_Depth LR_value]'; 
end