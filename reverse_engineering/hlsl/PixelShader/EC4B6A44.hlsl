//tress shadows! trzeba ruszyc eran

/*
    ps_1_1
    tex t0
    mul r0, t0, c0
	*/

sampler samp0: register(s0);
float4 p0 : register(c0);

float4 main( float2 t0 : TEXCOORD0) : COLOR {
	return tex2D(samp0, t0) * p0;
}