sampler samp: register(s0);

float4 main( float4 color : COLOR1) : COLOR0 {
	color.xyz = saturate(color);
	return color;
}