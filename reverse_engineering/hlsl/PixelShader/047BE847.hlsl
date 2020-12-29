//GUI
/*
    ps_1_1
    tex t0
    mul r0, t0, v0
*/

sampler samp0: register(s0);

float4 main( float2 tex0 : TEXCOORD0, //tekstura podstawowa
			 float4 color0 : COLOR0) : COLOR {
	return tex2D(samp0, tex0) * color0;
}